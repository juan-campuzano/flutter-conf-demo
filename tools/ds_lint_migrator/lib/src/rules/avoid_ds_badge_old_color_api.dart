import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../fixes/rename_badge_color_to_variant_fix.dart';

/// Detecta `DsBadge(color: ...)`, removido en `design_system` v3.0.0 en
/// favor de `DsBadge(variant: ...)` (tipo `DsBadgeVariant`).
///
/// A diferencia de `avoid_ds_button_old_label_param` (solo renombra un
/// parámetro) o `avoid_ds_alert_old_severity` (solo renombra un tipo/valor),
/// esta regla cubre ambos cambios a la vez sobre el mismo argumento.
class AvoidDsBadgeOldColorApi extends DartLintRule {
  AvoidDsBadgeOldColorApi() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ds_badge_old_color_api',
    problemMessage:
        "DsBadge ya no acepta el parámetro 'color' (API v1/v2, tipo 'DsBadgeColor'). Usa 'variant' (API v3, tipo 'DsBadgeVariant').",
    correctionMessage:
        "Renombra 'color:' a 'variant:' y ajusta el valor ('error' → 'danger', 'info' → 'neutral').",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.name2.lexeme;
      if (typeName != 'DsBadge') return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression && arg.name.label.name == 'color') {
          reporter.atNode(arg, _code);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RenameBadgeColorToVariantFix()];
}
