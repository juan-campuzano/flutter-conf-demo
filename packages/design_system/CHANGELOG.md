# Changelog

## 3.0.0

- **BREAKING** `DsTextField`: el parámetro nombrado `hintText` fue renombrado a `placeholder`.
- **BREAKING** `DsBadge`: el parámetro nombrado `color` fue renombrado a `variant`, y su tipo (`DsBadgeColor` → `DsBadgeVariant`) cambió los valores `error`/`info` a `danger`/`neutral` (`success`/`warning` sin cambio).
- Ver la guía de migración: [`docs/migrations/v2-to-v3.md`](docs/migrations/v2-to-v3.md). Ambos cambios están cubiertos por el plugin `ds_lint_migrator` (custom_lint).

## 2.0.0

- **BREAKING** `DsButton`: el parámetro nombrado `label` fue renombrado a `text`.
- **BREAKING** `DsAlertBanner`: el enum `DsAlertSeverity` fue renombrado a `DsAlertLevel`, y su valor `warning` fue renombrado a `caution` (`info`/`error` sin cambio).
- Ver la guía de migración: [`docs/migrations/v1-to-v2.md`](docs/migrations/v1-to-v2.md). Ambos cambios están cubiertos por el plugin `ds_lint_migrator` (custom_lint).

## 1.0.0

- Versión inicial: 11 componentes base del design system bancario (`DsButton`, `DsTextField`, `DsCard`, `DsAvatar`, `DsBadge`, `DsAppBar`, `DsBottomNavBar`, `DsListTile`, `DsAmountLabel`, `DsAlertBanner`, `DsLoadingIndicator`) y tokens (`DsColors`, `DsSpacing`, `DsTypography`).
