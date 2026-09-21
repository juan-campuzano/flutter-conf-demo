# Combining two git-sourced sibling packages: a pub resolver trap

This isn't specific to custom_lint, but it shows up in exactly the kind of
monorepo where you'd build a custom_lint migration plugin (a versioned design
system, a versioned "experience"/feature package, an app consuming both via git
tags), so it's worth knowing about together.

## Symptom

Inside your monorepo (a Dart workspace), everything resolves fine. But if you
try to consume two sibling packages from that monorepo as plain `git:`
dependencies from an *external* project — e.g. simulating how a real consumer
outside the workspace would pin them by tag — pub fails:

```
Because every version of package_b from git depends on package_a from git
<url> at <commit-sha> in packages/package_a and your_app depends on package_a
from git <url> at <tag-name> in packages/package_a, package_b from git is
forbidden.
```

## Root cause

Inside the monorepo, `package_b`'s `pubspec.yaml` depends on its sibling like
this (correct for local development):

```yaml
dependencies:
  package_a:
    path: ../package_a
```

When an external consumer fetches `package_b` via `git:` (pinned to a tag),
pub resolves that internal `path:` dependency by rewriting it into an implicit
git dependency pinned to the **exact commit SHA** of that same checkout. Your
app, meanwhile, depends on `package_a` directly with its own `ref:` (a tag
name). Even though the tag and the SHA point at the identical commit, pub
compares the two dependency *descriptions* — one keyed by SHA, one by tag name —
and treats them as different sources for the same package, which it refuses to
resolve together.

This is a real pub resolver rough edge with relative `path:` dependencies
between git-sourced siblings, not a mistake in how the packages are set up.

## Fix: pin one source explicitly with `dependency_overrides`

In the *external consumer's* project (not inside the monorepo/workspace — pub
refuses `dependency_overrides` on packages that are members of the same
workspace, with "Cannot override workspace packages"):

```yaml
# pubspec_overrides.yaml
dependency_overrides:
  package_a:
    git:
      url: https://github.com/<org>/<repo>.git
      path: packages/package_a
      ref: package_a-v1.0.0
```

This forces a single, explicit source for `package_a`, so the resolver no
longer has two conflicting descriptions to reconcile. Verified working: with
this override in place, `dart pub get` resolves both `package_a` and
`package_b` together against real tags on GitHub.

If you maintain the monorepo, it's worth documenting this override snippet
somewhere external consumers will find it (a `docs/consuming-externally.md` or
similar) rather than leaving them to discover the resolver error on their own.
