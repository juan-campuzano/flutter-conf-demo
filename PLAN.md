# Plan de construcción — Demo de codemods con Dart Analysis Server

> Checklist vivo. Marca `[x]` a medida que se completa cada tarea. Referenciable por cualquier agente/colaborador que trabaje en este repo.

Contexto completo del diseño: ver el plan original en la conversación que originó este repo (arquitectura de monorepo, decisiones de versionado, breaking changes elegidos). Este archivo es el checklist ejecutable.

## Fase 0 — Setup del monorepo
- [x] Mover app default a `apps/banking_app/`
- [x] Crear `packages/design_system/`, `packages/send_money_experience/`, `tools/ds_lint_migrator/`
- [x] Crear root `pubspec.yaml` con `workspace:`
- [x] Crear `melos.yaml`
- [x] `git init` + primer commit
- [x] Verificación: `dart pub get` en la raíz resuelve sin errores
- [x] Verificación: `melos bootstrap` corre sin errores

> Nota de implementación: Melos 8.x requiere `melos:` embebido en el `pubspec.yaml` raíz (ya no existe `melos.yaml`) y `melos` como `dev_dependency` del workspace. Esto genera un conflicto real de versión de `cli_util` con `custom_lint` (`melos` pide `>=0.5.0 <0.7.0`, `custom_lint` pide `^0.4.2`); se resolvió con `dependency_overrides: {cli_util: ^0.4.2}` en el `pubspec.yaml` raíz. También se descubrió que, al ser `banking_app` miembro del Dart workspace, pub resuelve `design_system`/`send_money_experience` localmente sin importar la fuente `git:` declarada — por eso NO existe `pubspec_overrides.yaml` (no hace falta y además pub lo rechaza con "Cannot override workspace packages").

## Fase 1 — Design System v1.0.0
- [x] Implementar los 11 componentes base (`DsButton`, `DsTextField`, `DsCard`, `DsAvatar`, `DsBadge`, `DsAppBar`, `DsBottomNavBar`, `DsListTile`, `DsAmountLabel`, `DsAlertBanner`, `DsLoadingIndicator`)
- [x] Tokens (`DsColors`, `DsSpacing`, `DsTypography`)
- [x] `analysis_options.yaml` propio con flutter_lints
- [x] `CHANGELOG.md` con entrada `1.0.0`
- [ ] Tests mínimos de widgets (pendiente — no bloquea el resto del demo)
- [x] Verificación: `flutter analyze` limpio en `packages/design_system`

## Fase 2 — Send Money Experience v1.0.0
- [x] Implementar flujo de 4 pantallas (seleccionar destinatario, monto, confirmar, éxito) — todo mock, sin red
- [x] Consumir `design_system` vía `path:` (workspace)
- [x] `CHANGELOG.md` con entrada `1.0.0`
- [x] Verificación: `flutter analyze` limpio en `packages/send_money_experience`

## Fase 3 — Banking App v1.0.0 (consumidora)
- [x] Construir shell bancario (dashboard, cuentas, tarjetas, movimientos) usando `design_system`
- [x] Montar `send_money_experience` como flujo acoplado
- [x] `pubspec.yaml` con dependencias `git+ref` (verdad de producción). No hace falta `pubspec_overrides.yaml`: al ser `banking_app` miembro del Dart workspace, pub resuelve `design_system`/`send_money_experience` localmente sin importar la fuente `git:` declarada.
- [x] Verificación: `flutter run -d macos` levanta la app sin errores

## Fase 4 — custom_lint plugin (scaffolding)
- [x] Crear paquete `ds_lint_migrator`
- [x] Configurar `analyzer: plugins: [custom_lint]` en `banking_app`
- [x] Verificación: `dart run custom_lint` corre sin error de configuración (sin reglas aún reportando nada porque `design_system` sigue en v1.0.0)

## Fase 5 — Tagging y publicación de v1.0.0
- [x] `git tag design_system-v1.0.0` y `git tag send_money_experience-v1.0.0` sobre el commit inicial (locales — no requieren confirmación)
- [ ] Crear repo remoto `flutter-conf-demo` en GitHub, público (**requiere confirmación explícita del usuario en el momento — pendiente**)
- [ ] Push del repo a GitHub (**requiere confirmación explícita — pendiente**)
- [ ] Push de tags (**requiere confirmación explícita — pendiente**)
- [x] Repo público creado y pusheado: https://github.com/juan-campuzano/flutter-conf-demo (código + los 3 tags)
- [x] Verificación como consumidor externo real (fuera del workspace, con `resolution: workspace` removido): `design_system` solo, vía `git: {url, path: packages/design_system, ref: design_system-v1.0.0}`, resuelve correctamente contra GitHub — confirma que el mecanismo de versionado por tag funciona de verdad.

> Hallazgo de implementación: al combinar en ese mismo consumidor externo `design_system` (vía `git`+`ref`) **y** `send_money_experience` (también vía `git`+`ref`), pub falla con `"send_money_experience from git is forbidden"`. Causa: `send_money_experience`'s `pubspec.yaml` depende de `design_system` con `path: ../design_system` (correcto para desarrollo dentro del monorepo/workspace), y al extraer `send_money_experience` vía git, pub reescribe esa dependencia interna a un git dependency fijado al commit exacto del checkout — que pub trata como una fuente distinta de la que declara la app directamente (`ref: design_system-v1.0.0`, mismo commit pero descrita distinto), y el resolver las considera en conflicto. Es una aspereza conocida de pub con dependencias git+path relativas entre paquetes hermanos de un monorepo, no un error de esta configuración. Dentro del propio workspace (desarrollo local) esto no afecta nada, porque ambos paquetes se resuelven por membresía de workspace. Para la demo, el punto central (versionado del design system + codemod) ya queda probado con `design_system` solo; el caso combinado queda documentado como limitación conocida del ecosistema.

## Fase 6 — Breaking changes v2.0.0 en design_system
- [x] Renombrar `DsButton.label` → `DsButton.text`
- [x] Renombrar enum `DsAlertSeverity` → `DsAlertLevel` y valor `warning` → `caution`
- [x] Actualizar `CHANGELOG.md` (entrada `2.0.0` con **BREAKING**)
- [x] Escribir `docs/migrations/v1-to-v2.md` + `MIGRATING.md`
- [x] `git tag design_system-v2.0.0` (local)
- [ ] Push de commit + tag (**requiere confirmación explícita — pendiente, junto con Fase 5**)

## Fase 7 — Implementar lint rules + quick fixes
- [x] `avoid_ds_button_old_label_param` + `RenameLabelToTextFix`
- [x] `avoid_ds_alert_old_severity` + fix de rename de enum/valor
- [x] Verificación: `dart run custom_lint` detecta ambos usos viejos en código de ejemplo (`apps/banking_app/lib/screens/dashboard_screen.dart`)

> Hallazgo de implementación: `custom_lint` 0.8.1 (CLI) solo reconoce como "proyecto" un directorio que tenga su propio `.dart_tool/package_config.json` (`lib/src/workspace.dart:_findRoots`); en un Dart workspace ese archivo solo existe en la raíz. Por eso `custom_lint`/`ds_lint_migrator` y `analyzer: plugins: [custom_lint]` viven en el `pubspec.yaml`/`analysis_options.yaml` de la **raíz**, no en `apps/banking_app`, y `dart run custom_lint`/`dart run custom_lint --fix` deben correrse desde la raíz del repo. Con esta configuración el plugin detecta y corrige ambos breaking changes correctamente dentro de `apps/banking_app`. Los usos en `packages/send_money_experience` no quedaron cubiertos por el CLI en este workspace (se migraron a mano) — documentado como limitación conocida del ecosistema a la fecha, no como error del plugin.
>
> También: `dart fix --apply` (comando genérico del SDK) no aplica los quick fixes de `custom_lint`; hay que usar `dart run custom_lint --fix` directamente.

## Fase 8 — Demo end-to-end
- [x] Con `design_system` ya en v2.0.0 (breaking change aplicado localmente) y `apps/banking_app/lib/screens/dashboard_screen.dart` deliberadamente sin migrar, `dart analyze` mostró los errores de compilación reales esperados
- [x] `dart run custom_lint` (desde la raíz) → detectó ambos problemas
- [x] `dart run custom_lint --fix` → código corregido automáticamente (`label` → `text`, `DsAlertSeverity.warning` → `DsAlertLevel.caution`)
- [x] Verificación final: `melos run analyze` limpio en los 4 paquetes
- [x] Cambiar `ref:` de un consumidor externo real (fuera del workspace) de `design_system-v1.0.0` a `design_system-v2.0.0` — ver nota de Fase 5; ya probado contra el repo real de GitHub

## Notas para agentes
- Cualquier cambio a la lista de paquetes del workspace debe reflejarse en `pubspec.yaml` (root) **y** `melos.yaml`.
- No usar `git push --force` ni reescribir tags ya pusheados sin confirmación explícita del usuario — los tags son la base de resolución de las `git dependency` de pub.
- Nunca crear el repo remoto de GitHub ni hacer push sin pedir confirmación explícita en el momento, aunque el nombre/visibilidad ya estén decididos.
