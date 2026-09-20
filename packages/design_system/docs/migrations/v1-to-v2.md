# Migración design_system v1.0.0 → v2.0.0

Dos breaking changes, ambos cubiertos por el plugin `ds_lint_migrator` (custom_lint) — ver [`tools/ds_lint_migrator`](../../../../tools/ds_lint_migrator).

## 1. `DsButton.label` renombrado a `DsButton.text`

**Antes (v1):**
```dart
DsButton(label: 'Enviar', onPressed: () {})
```

**Después (v2):**
```dart
DsButton(text: 'Enviar', onPressed: () {})
```

Cubierto por la regla `avoid_ds_button_old_label_param` y el quick fix `RenameLabelToTextFix`.

## 2. `DsAlertSeverity` renombrado a `DsAlertLevel` (y `.warning` a `.caution`)

**Antes (v1):**
```dart
DsAlertBanner(
  message: 'Revisa tu saldo',
  severity: DsAlertSeverity.warning,
)
```

**Después (v2):**
```dart
DsAlertBanner(
  message: 'Revisa tu saldo',
  severity: DsAlertLevel.caution,
)
```

El nombre del parámetro (`severity:`) no cambia — solo el tipo del enum y el valor `warning`. `DsAlertSeverity.info` y `DsAlertSeverity.error` se renombran a `DsAlertLevel.info`/`DsAlertLevel.error` sin cambiar de valor semántico.

Cubierto por la regla `avoid_ds_alert_old_severity` y el quick fix `RenameAlertSeverityFix`.

## Migración automática

```bash
dart pub get
dart run custom_lint
dart fix --apply
```

O, desde el IDE, aplica el quick fix ofrecido sobre cada warning (ícono de bombilla / `Cmd+.`).
