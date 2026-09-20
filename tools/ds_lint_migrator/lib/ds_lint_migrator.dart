import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/rules/avoid_ds_alert_old_severity.dart';
import 'src/rules/avoid_ds_button_old_label_param.dart';

PluginBase createPlugin() => _DsLintMigratorPlugin();

class _DsLintMigratorPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        AvoidDsButtonOldLabelParam(),
        AvoidDsAlertOldSeverity(),
      ];
}
