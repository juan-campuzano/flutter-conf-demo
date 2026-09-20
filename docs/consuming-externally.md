# Consumir `design_system` y `send_money_experience` fuera de este monorepo

Este repo es un [Dart workspace](https://dart.dev/tools/pub/workspaces): dentro de él, `apps/banking_app` resuelve `design_system` y `send_money_experience` automáticamente por membresía de workspace, sin importar la fuente `git:` declarada en su `pubspec.yaml`.

Si en cambio quieres consumir estos paquetes desde **otro** proyecto (fuera de este workspace) —por ejemplo, clonando solo `apps/banking_app` como si fuera una app independiente—, apunta a un tag específico vía `git` + `path`:

```yaml
# pubspec.yaml
dependencies:
  design_system:
    git:
      url: https://github.com/juan-campuzano/flutter-conf-demo.git
      path: packages/design_system
      ref: design_system-v1.0.0 # o design_system-v2.0.0

  send_money_experience:
    git:
      url: https://github.com/juan-campuzano/flutter-conf-demo.git
      path: packages/send_money_experience
      ref: send_money_experience-v1.0.0
```

## Un detalle si usas ambos paquetes a la vez

`send_money_experience` depende internamente de `design_system` con `path: ../design_system` (correcto dentro del monorepo). Al extraer `send_money_experience` vía `git`, pub reescribe esa dependencia interna como un git dependency fijado al commit exacto de ese checkout — una descripción de fuente distinta a la que tu `pubspec.yaml` declara directamente para `design_system` (aunque resuelvan al mismo commit). Sin ayuda, pub falla con:

```
Because every version of send_money_experience from git depends on design_system from git ... and
<tu_app> depends on design_system from git ... , send_money_experience from git is forbidden.
```

**Arreglo:** agrega un `pubspec_overrides.yaml` junto a tu `pubspec.yaml` fijando una única fuente para `design_system`:

```yaml
# pubspec_overrides.yaml
dependency_overrides:
  design_system:
    git:
      url: https://github.com/juan-campuzano/flutter-conf-demo.git
      path: packages/design_system
      ref: design_system-v1.0.0
```

Con esto, `dart pub get` resuelve ambos paquetes sin conflicto. Verificado contra los tags reales de este repo.
