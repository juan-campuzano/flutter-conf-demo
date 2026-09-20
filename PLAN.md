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
- [ ] Verificación: `flutter run` levanta la app sin errores (pendiente de probar en un dispositivo/emulador; `dart analyze`/`dart pub get` ya son limpios)

## Fase 4 — custom_lint plugin (scaffolding)
- [x] Crear paquete `ds_lint_migrator`
- [x] Configurar `analyzer: plugins: [custom_lint]` en `banking_app`
- [x] Verificación: `dart run custom_lint` corre sin error de configuración (sin reglas aún reportando nada porque `design_system` sigue en v1.0.0)

## Fase 5 — Tagging y publicación de v1.0.0
- [ ] Crear repo remoto `flutter-conf-demo` en GitHub, público (**requiere confirmación explícita del usuario en el momento**)
- [ ] Push del repo a GitHub (**requiere confirmación explícita**)
- [ ] `melos version design_system` → tag `design_system-v1.0.0`
- [ ] `melos version send_money_experience` → tag `send_money_experience-v1.0.0`
- [ ] Push de tags (**requiere confirmación explícita**)
- [ ] Verificación: `dart pub get` en `banking_app` (sin override) resuelve el `ref` real desde GitHub

## Fase 6 — Breaking changes v2.0.0 en design_system
- [ ] Renombrar `DsButton.label` → `DsButton.text`
- [ ] Renombrar enum `DsAlertSeverity` → `DsAlertLevel` y valor `warning` → `caution`
- [ ] Actualizar `CHANGELOG.md` (entrada `2.0.0` con **BREAKING**)
- [ ] Escribir `docs/migrations/v1-to-v2.md` + `MIGRATING.md`
- [ ] `melos version design_system --major` → tag `design_system-v2.0.0`
- [ ] Push de commit + tag (**requiere confirmación explícita**)

## Fase 7 — Implementar lint rules + quick fixes
- [ ] `avoid_ds_button_old_label_param` + `RenameLabelToTextFix`
- [ ] `avoid_ds_alert_old_severity` + fix de rename de enum/valor
- [ ] Verificación: `dart run custom_lint` detecta ambos usos viejos en código de ejemplo

## Fase 8 — Demo end-to-end
- [ ] Cambiar `ref:` de `banking_app` a `design_system-v2.0.0`
- [ ] `dart pub get` → errores de compilación esperados (breaking change real)
- [ ] `dart run custom_lint` → detecta ambos problemas
- [ ] Aplicar quick fixes (IDE o `dart fix --apply`) → código corregido automáticamente
- [ ] Verificación final: `flutter analyze` limpio, `flutter run` funciona con v2

## Notas para agentes
- Cualquier cambio a la lista de paquetes del workspace debe reflejarse en `pubspec.yaml` (root) **y** `melos.yaml`.
- No usar `git push --force` ni reescribir tags ya pusheados sin confirmación explícita del usuario — los tags son la base de resolución de las `git dependency` de pub.
- Nunca crear el repo remoto de GitHub ni hacer push sin pedir confirmación explícita en el momento, aunque el nombre/visibilidad ya estén decididos.
