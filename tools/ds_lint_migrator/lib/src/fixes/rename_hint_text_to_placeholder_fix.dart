import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Quick fix que renombra `hintText:` a `placeholder:` en construcciones de
/// `DsTextField`.
class RenameHintTextToPlaceholderFix extends DartFix {
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
        if (arg is NamedExpression &&
            arg.name.label.name == 'hintText' &&
            analysisError.sourceRange.intersects(arg.sourceRange)) {
          final changeBuilder = reporter.createChangeBuilder(
            message: "Renombrar 'hintText' a 'placeholder'",
            priority: 1,
          );
          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(arg.name.label.sourceRange, 'placeholder');
          });
        }
      }
    });
  }
}
