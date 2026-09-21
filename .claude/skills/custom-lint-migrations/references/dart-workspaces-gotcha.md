# custom_lint vs. Dart workspaces (pub workspaces)

Verified against `custom_lint` 0.8.1 / `custom_lint_core` 0.8.1 / Dart SDK 3.13.3
(late 2026). Re-check if a much newer custom_lint version is in play — this may
have been fixed upstream, but as of this writing it has not.

## Symptom

In a repo using [Dart workspaces](https://dart.dev/tools/pub/workspaces) (a root
`pubspec.yaml` with a `workspace:` list, member packages with
`resolution: workspace`), you've done everything the single-package custom_lint
docs say to do:

- `analyzer: plugins: [custom_lint]` in the consuming app's `analysis_options.yaml`
- `custom_lint` and your plugin package under the app's `dev_dependencies:`
- `dart pub get` succeeds, no errors

...and yet `dart run custom_lint` (run from inside the app's own directory)
always prints `No issues found!`, even on code you are certain violates a rule.
Throwing an exception inside the rule's `run()` never surfaces anywhere — proof
the rule is never even being invoked.

## Root cause

`custom_lint`'s CLI decides which directories are analyzable "projects" using
`CustomLintWorkspace._findRoots` (in `custom_lint`'s `lib/src/workspace.dart`).
For every `pubspec.yaml` or `analysis_options.yaml` file it finds recursively, it
keeps only the ones whose **parent directory has its own
`.dart_tool/package_config.json`**:

```dart
return file.parent.packageConfig.existsSync();
// where packageConfig => file('.dart_tool', 'package_config.json')
```

That's a plain, non-recursive existence check on that exact directory — it does
not walk up looking for an ancestor's package_config the way Dart's own package
resolution does for workspace members.

In a Dart workspace, **only the workspace root** ends up with a real
`.dart_tool/package_config.json`. Member packages/apps (`apps/foo`,
`packages/bar`, ...) get their dependencies resolved through the root's shared
lockfile and package_config — they don't get their own local copy. So when you
run `dart run custom_lint` from inside `apps/foo`, every `pubspec.yaml`/
`analysis_options.yaml` under that scan — including `apps/foo`'s own — fails the
`packageConfig.existsSync()` check, `_findRoots` returns nothing, and custom_lint
silently analyzes zero files. No error, no warning — it just finds nothing to do
and happily reports success.

(You can confirm this yourself: `find . -name package_config.json` in a Dart
workspace repo returns exactly one file, at the workspace root.)

## The fix

Move the custom_lint configuration from the member app to the **workspace
root**, since the root is the only directory guaranteed to have its own
`package_config.json`:

```yaml
# <workspace-root>/analysis_options.yaml
analyzer:
  plugins:
    - custom_lint
```

```yaml
# <workspace-root>/pubspec.yaml
dev_dependencies:
  custom_lint: ^0.8.1
  my_lints:
    path: tools/my_lints   # path relative to the root, not to the app
```

Then always invoke it from the root:

```bash
dart run custom_lint          # from the workspace root, not apps/foo
dart run custom_lint --fix
```

`dart analyze .` run from the root will still correctly show errors across every
member package (that's a different, more robust code path in the analyzer
itself) — this bug is specific to custom_lint's own project-discovery logic, not
to Dart's analyzer in general. That's also why a plain `dart analyze` "seeing"
everything while `dart run custom_lint` sees nothing is a strong signal you've
hit exactly this issue.

## Known residual limitation

Registering the plugin at the root generally surfaces issues correctly for files
that live in whichever member directory you're actively testing, but coverage
across *every* member package in one run is not guaranteed — in one observed
case, a rule fired correctly for files under `apps/foo` but not for files with
the identical violating pattern under a sibling `packages/bar`, with no error
explaining the gap. If a rule seems to work for one package but not another
sibling package in the same workspace, don't assume the rule logic is
package-specific — it likely isn't. Try analyzing the "missing" package on its
own (temporarily outside the workspace, or as the sole target) to confirm the
rule itself is sound before spending time hunting for a difference between the
files. Mention this explicitly to the user as a known tooling limitation rather
than silently working around it, since the workaround (moving code, or manually
fixing the sibling package by hand) is a real tradeoff they should be aware of.
