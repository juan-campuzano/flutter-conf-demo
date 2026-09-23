# Changelog

## 0.2.0

- Reglas y quick fixes para migrar `design_system` v2 → v3:
  - `avoid_ds_text_field_old_hint_param`: `DsTextField.hintText` → `DsTextField.placeholder`.
  - `avoid_ds_badge_old_color_api`: `DsBadge.color` (`DsBadgeColor`) → `DsBadge.variant` (`DsBadgeVariant`), renombrando el argumento, el tipo y el valor en un solo quick fix.
- `bin/migrate_workspace.dart`: codemod standalone con `package:analyzer` (sin `custom_lint`) para migrar `DsBadge(color: ...)` en batch sobre todo el workspace.

## 0.1.0

- Reglas y quick fixes para migrar `design_system` v1 → v2:
  - `avoid_ds_button_old_label_param`: `DsButton.label` → `DsButton.text`.
  - `avoid_ds_alert_old_severity`: `DsAlertSeverity` → `DsAlertLevel` (y `.warning` → `.caution`).
