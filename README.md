# flutter-conf-demo

Monorepo de demostración: cómo usar el Dart Analysis Server para migrar código automáticamente ("codemods") entre versiones de un sistema de diseño.

Todo el contenido es visual/mock — no hay llamadas de red ni datos reales. Ver el checklist de construcción en [`PLAN.md`](PLAN.md).

## Paquetes

| Paquete | Ubicación | Qué es |
|---|---|---|
| `banking_app` | `apps/banking_app` | Shell bancario ficticio que consume el design system y la experiencia de envío de dinero |
| `design_system` | `packages/design_system` | Sistema de diseño versionado (11 componentes) |
| `send_money_experience` | `packages/send_money_experience` | Experiencia de "envío de dinero" acoplable, versionada por separado |
| `ds_lint_migrator` | `tools/ds_lint_migrator` | Plugin `custom_lint` (analysis server) con las reglas y quick fixes que migran código entre versiones del design system |

## Monorepo tooling

- **Dart Workspaces** (`workspace:` en el `pubspec.yaml` raíz) resuelve las dependencias locales entre paquetes con un único `pubspec.lock`.
- **Melos** (`melos.yaml`) orquesta bootstrap, scripts (`melos run analyze`, `melos run lint:custom`) y versionado/changelogs independientes por paquete (`melos version <paquete>`), generando tags con el formato `<paquete>-v<semver>`.

## Setup

```bash
dart pub get       # resuelve el workspace completo
melos bootstrap    # bootstrap de Melos sobre los mismos paquetes
```

## Consumo versionado

`apps/banking_app/pubspec.yaml` declara `design_system` y `send_money_experience` como dependencias `git` con `path` + `ref` a un tag específico (así se demuestran migraciones reales entre versiones). Dentro de este workspace, pub resuelve ambos paquetes localmente por membresía de workspace sin tocar la red. Para consumirlos desde fuera de este monorepo, ver [`docs/consuming-externally.md`](docs/consuming-externally.md).
