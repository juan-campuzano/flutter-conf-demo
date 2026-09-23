# ds_lint_migrator

Reglas de lint y quick fixes (`custom_lint`) que migran código consumidor entre versiones de `design_system`, más un codemod standalone que hace lo mismo con `package:analyzer` directamente.

## 1. Plugin `custom_lint` (integrado al analysis server / IDE)

```bash
dart run custom_lint          # detecta usos de API vieja
dart run custom_lint --fix    # aplica los quick fixes
```

Reglas actuales:

| Regla | Detecta | Quick fix |
|---|---|---|
| `avoid_ds_button_old_label_param` | `DsButton(label: ...)` | Renombra a `text:` |
| `avoid_ds_alert_old_severity` | `DsAlertSeverity` | Renombra a `DsAlertLevel` (y `.warning` → `.caution`) |
| `avoid_ds_text_field_old_hint_param` | `DsTextField(hintText: ...)` | Renombra a `placeholder:` |
| `avoid_ds_badge_old_color_api` | `DsBadge(color: ...)` | Renombra a `variant:` + tipo (`DsBadgeColor` → `DsBadgeVariant`) + valor (`error`→`danger`, `info`→`neutral`) en un solo cambio |

Corre desde la raíz del workspace (ver nota en `PLAN.md` sobre por qué `custom_lint` no descubre paquetes individuales dentro de un Dart workspace).

## 2. Codemod standalone (`bin/migrate_workspace.dart`)

Usa `AnalysisContextCollection` de `package:analyzer` directamente — sin `custom_lint_builder` ni analysis server del IDE de por medio — para recorrer el AST resuelto de cada archivo del workspace y reescribir `DsBadge(color: ...)` a `DsBadge(variant: ...)`.

```bash
dart run tools/ds_lint_migrator/bin/migrate_workspace.dart
```

Pensado como ejemplo de migración batch (p. ej. en CI, o para consumidores que no corren `custom_lint`): mismo análisis semántico del código, expuesto vía la API pública de `analyzer` en lugar del protocolo de plugins del analysis server.
