import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../fixes/rename_hint_text_to_placeholder_fix.dart';

/// Detecta `DsTextField(hintText: ...)`, removido en `design_system` v3.0.0
/// en favor de `DsTextField(placeholder: ...)`.
class AvoidDsTextFieldOldHintParam extends DartLintRule {
  AvoidDsTextFieldOldHintParam() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ds_text_field_old_hint_param',
    problemMessage:
        "DsTextField ya no acepta el parámetro 'hintText' (API v1/v2). Usa 'placeholder' (API v3 del design system).",
    correctionMessage: "Renombra 'hintText:' a 'placeholder:'.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.name2.lexeme;
      if (typeName != 'DsTextField') return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression && arg.name.label.name == 'hintText') {
          reporter.atNode(arg, _code);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RenameHintTextToPlaceholderFix()];
}
