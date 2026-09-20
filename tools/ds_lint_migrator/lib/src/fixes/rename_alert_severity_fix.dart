import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Quick fix que renombra `DsAlertSeverity` a `DsAlertLevel`, y `.warning` a
/// `.caution` cuando se accede a través de ese tipo.
class RenameAlertSeverityFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addNamedType((node) {
      if (node.name2.lexeme == 'DsAlertSeverity' &&
          analysisError.sourceRange.intersects(node.sourceRange)) {
        final changeBuilder = reporter.createChangeBuilder(
          message: "Renombrar 'DsAlertSeverity' a 'DsAlertLevel'",
          priority: 1,
        );
        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(node.name2.sourceRange, 'DsAlertLevel');
        });
      }
    });

    context.registry.addPrefixedIdentifier((node) {
      if (node.prefix.name == 'DsAlertSeverity' &&
          analysisError.sourceRange.intersects(node.sourceRange)) {
        final changeBuilder = reporter.createChangeBuilder(
          message: "Renombrar a 'DsAlertLevel'"
              "${node.identifier.name == 'warning' ? ".caution" : ""}",
          priority: 1,
        );
        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(node.prefix.sourceRange, 'DsAlertLevel');
          if (node.identifier.name == 'warning') {
            builder.addSimpleReplacement(node.identifier.sourceRange, 'caution');
          }
        });
      }
    });
  }
}
