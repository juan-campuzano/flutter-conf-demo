---
name: custom-lint-migrations
description: >-
  Write and debug custom_lint plugins (package:custom_lint_builder) for Dart/Flutter —
  especially lint rules with automatic quick fixes that migrate code across a breaking
  API change (renamed parameters, renamed types, moved packages). Use this whenever
  the user wants a codemod, an automated migration for a breaking change, a "fix"
  that the analyzer/IDE can apply automatically, or asks about writing a custom
  analyzer/lint plugin — even if they just say "can we auto-fix this everywhere" or
  "write a lint that catches the old API". Also use it when custom_lint is already
  set up but misbehaving: rules not firing, "No issues found!" when it clearly should
  find something, `dart fix --apply` not doing anything, or anything involving
  custom_lint inside a Dart workspace / pub workspaces monorepo (apps/, packages/,
  a root pubspec.yaml with a `workspace:` field) — that combination has a specific,
  non-obvious failure mode covered here.
---

# custom_lint migrations

`custom_lint` lets you ship a lint rule *and* a quick fix together, so the Dart
Analysis Server (IDE lightbulb, `dart run custom_lint --fix`) can migrate code
automatically. This is the right tool whenever a package owner ships a breaking
API change and wants consumers to get an automatic codemod instead of a paragraph
in a migration guide nobody reads.

Two very different jobs live under this skill — figure out which one the user
needs before diving in:

1. **Writing a new rule + fix** for a specific breaking change → see "Writing a
   rule and fix" below.
2. **Something's already built and isn't working** ("no issues found" but there
   should be some, fixes not applying, IDE not picking it up) → skip straight to
   "Debugging: it's not detecting anything" — nine times out of ten this is a
   project-structure problem, not a bug in the rule's logic.

## Anatomy of a plugin package

A custom_lint plugin is an ordinary Dart package with one required shape:

```yaml
# my_lints/pubspec.yaml
name: my_lints
environment:
  sdk: ^3.0.0
dependencies:
  analyzer: ^8.0.0          # match whatever custom_lint_core needs — check its pubspec
  custom_lint_builder: ^0.8.1
dev_dependencies:
  custom_lint: ^0.8.1
```

**`custom_lint_builder` must be under `dependencies:`, not `dev_dependencies:`.**
custom_lint decides whether a package *is* a plugin by checking
`pubspec.dependencies.containsKey('custom_lint_builder')` — under `dev_dependencies`
it's invisible to that check and the whole package gets silently ignored.

The entrypoint is `lib/<package_name>.dart` (must match the package name exactly):

```dart
// lib/my_lints.dart
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/rules/my_rule.dart';

PluginBase createPlugin() => _MyLintsPlugin();

class _MyLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [MyRule()];
}
```

## Writing a rule and fix

Think of each breaking change as one rule + one fix, named after what it detects
(`avoid_old_thing_param`, not `fix_1`). Keep them small and specific — one rule per
distinct syntactic pattern you need to catch, so error messages stay precise and
fixes stay simple to reason about.

**The rule** visits AST nodes and reports the ones matching the old API shape:

```dart
// lib/src/rules/avoid_old_label_param.dart
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';   // ErrorReporter lives here
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../fixes/rename_label_to_text_fix.dart';

class AvoidOldLabelParam extends DartLintRule {
  AvoidOldLabelParam() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_old_label_param',
    problemMessage: "MyWidget no longer accepts 'label' — use 'text' instead.",
    correctionMessage: "Rename 'label:' to 'text:'.",
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name2.lexeme != 'MyWidget') return;
      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression && arg.name.label.name == 'label') {
          reporter.atNode(arg, _code);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RenameLabelToTextFix()];
}
```

**The fix** re-runs the same node matching (fixes get the `AnalysisError` for the
reported range, not the AST node directly) and edits the source:

```dart
// lib/src/fixes/rename_label_to_text_fix.dart
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;  // see note below
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RenameLabelToTextFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression &&
            arg.name.label.name == 'label' &&
            analysisError.sourceRange.intersects(arg.sourceRange)) {
          final builder = reporter.createChangeBuilder(message: "Rename to 'text'", priority: 1);
          builder.addDartFileEdit((b) => b.addSimpleReplacement(arg.name.label.sourceRange, 'text'));
        }
      }
    });
  }
}
```

**Import gotcha:** both `package:analyzer/error/error.dart` and
`package:custom_lint_builder` (transitively, `custom_lint_core`) export a
`LintCode` symbol. If you import both plainly, `LintCode(...)` becomes ambiguous
and won't compile. Fix it with `import 'package:analyzer/error/error.dart' hide LintCode;`
wherever you need `AnalysisError` from that library alongside custom_lint's own
`LintCode`. `ErrorReporter` lives in `package:analyzer/error/listener.dart`, a
separate import — pull only what you actually reference to avoid unused-import
warnings and dodge the ambiguity in the first place when you can.

For enum/type renames rather than parameter renames, the same shape applies but
you visit `addNamedType` (for the type reference) and `addPrefixedIdentifier` (for
`OldType.value` access) instead of `addInstanceCreationExpression`. Write the rule
against the literal old name as a string — it's a syntactic check, so it works
whether or not the "new" name has even shipped yet, and it deliberately does **not**
require the analyzed code to depend on a specific version of the package that owns
the API. That's what lets you build and test the rule before the breaking release
even exists.

## Wiring it into a consuming project

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - custom_lint
```

```yaml
# pubspec.yaml
dev_dependencies:
  custom_lint: ^0.8.1
  my_lints:
    path: ../my_lints   # or a git/hosted dependency once published
```

After `dart pub get`, run:

- `dart run custom_lint` — reports issues, same as what the IDE will show.
- `dart run custom_lint --fix` — applies every available fix.
  **`dart fix --apply` (the bare Dart SDK command) does not pick up custom_lint
  fixes** — that's a common trap. Always reach for `dart run custom_lint --fix`
  for anything produced by a custom_lint plugin.

## Debugging: it's not detecting anything

When `dart run custom_lint` says "No issues found!" and you're confident the code
has the pattern you're looking for, work through these in order — in practice the
project-structure ones (especially the workspace one) are far more common than a
bug in the rule's own logic:

1. **Is `custom_lint_builder` under `dependencies:` in the plugin's own
   `pubspec.yaml`?** Under `dev_dependencies:` it won't be recognized as a plugin
   at all (see "Anatomy" above).
2. **Are you inside a Dart workspace (pub workspaces)?** This is the single most
   likely cause and it's non-obvious enough to deserve its own section — see
   `references/dart-workspaces-gotcha.md`. Short version: custom_lint's CLI only
   treats a directory as an analyzable "project" if that exact directory has its
   own `.dart_tool/package_config.json`. In a Dart workspace only the workspace
   *root* has one. So `analyzer: plugins: [custom_lint]` and the
   `custom_lint`/plugin `dev_dependencies` must live in the **root**
   `pubspec.yaml`/`analysis_options.yaml`, not in the member package/app that
   actually needs the lints — and you must run `dart run custom_lint` from the
   workspace root, not from inside the member directory.
3. **Does the plugin package itself compile clean?** Run `dart analyze` inside
   the plugin package's own directory. If it has errors, custom_lint may fail to
   load it and (depending on version) fail silently rather than surfacing a clear
   error in the CLI output.
4. **Prove the rule's `run()` is even being invoked.** Temporarily replace the
   body with `throw StateError('probe')` and see whether anything surfaces (a
   background analyzer/IDE diagnostic is more likely to surface this than the
   bare CLI, which can swallow plugin-side exceptions quietly). If nothing
   surfaces even with a guaranteed throw, the plugin isn't loading — go back to
   points 1–3, it's a discovery problem, not a logic problem. Remove the probe
   once you've confirmed loading works.
5. **Restart the IDE / analysis server** after any change to `pubspec.yaml` or
   `analysis_options.yaml` plugin config — the Dart Analysis Server caches its
   plugin process and won't pick up new registrations without a restart in some
   editors.

## References

- `references/dart-workspaces-gotcha.md` — the full story on why custom_lint's
  project discovery breaks in a Dart workspace, the exact code path responsible,
  and the fix (config at the workspace root). Read this before assuming a
  monorepo + custom_lint setup "should just work" the way single-package docs
  describe.
- `references/external-consumer-git-deps.md` — a related but separate pub
  resolver issue: combining two git-sourced sibling packages (where one depends
  on the other via a relative `path:` inside the same repo) can make pub refuse
  to resolve them together for an external consumer, and how
  `dependency_overrides` fixes it.
