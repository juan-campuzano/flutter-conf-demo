import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../fixes/rename_label_to_text_fix.dart';

/// Detecta `DsButton(label: ...)`, removido en `design_system` v2.0.0
/// en favor de `DsButton(text: ...)`.
class AvoidDsButtonOldLabelParam extends DartLintRule {
  AvoidDsButtonOldLabelParam() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_ds_button_old_label_param',
    problemMessage:
        "DsButton ya no acepta el parámetro 'label' (API v1). Usa 'text' (API v2 del design system).",
    correctionMessage: "Renombra 'label:' a 'text:'.",
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final typeName = node.constructorName.type.name2.lexeme;
      if (typeName != 'DsButton') return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression && arg.name.label.name == 'label') {
          reporter.atNode(arg, _code);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RenameLabelToTextFix()];
}
