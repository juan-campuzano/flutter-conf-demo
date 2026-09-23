import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Mapa de valores `DsBadgeColor` → `DsBadgeVariant`. `success`/`warning` no
/// cambian de nombre, solo de tipo.
const _valueRenames = {'error': 'danger', 'info': 'neutral'};

/// Quick fix que renombra `color:` a `variant:` en construcciones de
/// `DsBadge`, junto con el tipo (`DsBadgeColor` → `DsBadgeVariant`) y el
/// valor del enum cuando corresponde (`error` → `danger`, `info` →
/// `neutral`), todo en un único cambio.
class RenameBadgeColorToVariantFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      for (final arg in node.argumentList.arguments) {
        if (arg is! NamedExpression ||
            arg.name.label.name != 'color' ||
            !analysisError.sourceRange.intersects(arg.sourceRange)) {
          continue;
        }

        final changeBuilder = reporter.createChangeBuilder(
          message: "Renombrar 'color' a 'variant'",
          priority: 1,
        );
        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(arg.name.label.sourceRange, 'variant');

          final value = arg.expression;
          if (value is PrefixedIdentifier && value.prefix.name == 'DsBadgeColor') {
            builder.addSimpleReplacement(value.prefix.sourceRange, 'DsBadgeVariant');
            final renamed = _valueRenames[value.identifier.name];
            if (renamed != null) {
              builder.addSimpleReplacement(value.identifier.sourceRange, renamed);
            }
          }
        });
      }
    });
  }
}
