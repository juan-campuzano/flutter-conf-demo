import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../fixes/rename_alert_severity_fix.dart';

/// Detecta el uso del tipo `DsAlertSeverity` (renombrado a `DsAlertLevel` en
/// `design_system` v2.0.0) y de su valor `.warning` (renombrado a `.caution`).
class AvoidDsAlertOldSeverity extends DartLintRule {
  AvoidDsAlertOldSeverity() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ds_alert_old_severity',
    problemMessage:
        "'DsAlertSeverity' fue renombrado a 'DsAlertLevel' en v2.0.0 del design system.",
    correctionMessage: "Usa 'DsAlertLevel' y renombra 'warning' a 'caution'.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNamedType((node) {
      if (node.name2.lexeme == 'DsAlertSeverity') {
        reporter.atNode(node, _code);
      }
    });

    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name == 'DsAlertSeverity') {
        reporter.atNode(node, _code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [RenameAlertSeverityFix()];
}
