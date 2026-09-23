# Migración design_system v2.0.0 → v3.0.0

Dos breaking changes, ambos cubiertos por el plugin `ds_lint_migrator` (custom_lint) — ver [`tools/ds_lint_migrator`](../../../../tools/ds_lint_migrator).

## 1. `DsTextField.hintText` renombrado a `DsTextField.placeholder`

**Antes (v2):**
```dart
DsTextField(label: 'Monto', hintText: '0.00')
```

**Después (v3):**
```dart
DsTextField(label: 'Monto', placeholder: '0.00')
```

Cubierto por la regla `avoid_ds_text_field_old_hint_param` y el quick fix `RenameHintTextToPlaceholderFix`.

## 2. `DsBadge.color` renombrado a `DsBadge.variant` (y `DsBadgeColor` a `DsBadgeVariant`)

A diferencia de la migración de `DsAlertSeverity` en v2 (donde solo cambiaba el tipo del enum, no el nombre del parámetro), acá cambian **ambos**: el nombre del parámetro y el tipo/valores del enum.

**Antes (v2):**
```dart
DsBadge(label: 'Rechazado', color: DsBadgeColor.error)
DsBadge(label: 'Pendiente', color: DsBadgeColor.info)
```

**Después (v3):**
```dart
DsBadge(label: 'Rechazado', variant: DsBadgeVariant.danger)
DsBadge(label: 'Pendiente', variant: DsBadgeVariant.neutral)
```

`DsBadgeColor.success` y `DsBadgeColor.warning` se renombran a `DsBadgeVariant.success`/`DsBadgeVariant.warning` sin cambiar de valor semántico.

Cubierto por la regla `avoid_ds_badge_old_color_api` y el quick fix `RenameBadgeColorToVariantFix`, que reescribe en un solo cambio el nombre del argumento (`color:` → `variant:`), el tipo del enum y — cuando aplica — el valor.

## Migración automática

```bash
dart pub get
dart run custom_lint
dart run custom_lint --fix
```

O, desde el IDE, aplica el quick fix ofrecido sobre cada warning (ícono de bombilla / `Cmd+.`).

También existe un codemod independiente de `custom_lint`, que usa `package:analyzer` directamente contra todo el workspace (útil para migraciones batch en CI, sin depender del analysis server del IDE):

```bash
dart run tools/ds_lint_migrator/bin/migrate_workspace.dart
```

Ver [`tools/ds_lint_migrator/README.md`](../../../../tools/ds_lint_migrator/README.md).
