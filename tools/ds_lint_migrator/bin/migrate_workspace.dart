// Codemod independiente de custom_lint: usa `package:analyzer` directamente
// (AnalysisContextCollection + AST) para migrar `DsTextField(hintText: ...)`
// a `DsTextField(placeholder: ...)` y `DsBadge(color: ...)` a
// `DsBadge(variant: ...)` en todo el workspace, sin pasar por el analysis
// server del IDE ni por el plugin de custom_lint. Útil, por ejemplo, para
// alcanzar paquetes que el CLI de custom_lint no descubre dentro de un Dart
// workspace (ver PLAN.md, Fase 7).
//
// Uso: dart run tools/ds_lint_migrator/bin/migrate_workspace.dart [ruta_repo]
//
// Ver docs/migrations/v2-to-v3.md.
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

/// `DsBadgeColor` → `DsBadgeVariant`. `success`/`warning` no cambian de
/// nombre, solo `error`/`info`.
const _valueRenames = {'error': 'danger', 'info': 'neutral'};

Future<void> main(List<String> args) async {
  final repoRoot = p.normalize(p.absolute(args.isNotEmpty ? args.first : Directory.current.path));
  final collection = AnalysisContextCollection(includedPaths: [repoRoot]);

  var filesChanged = 0;
  var sitesFixed = 0;

  for (final context in collection.contexts) {
    for (final path in context.contextRoot.analyzedFiles()) {
      if (!path.endsWith('.dart')) continue;
      // La definición de DsBadge no debe reescribirse a sí misma, y el
      // propio migrador no es un consumidor del design system.
      final segments = p.split(path);
      if (segments.contains('design_system') || segments.contains('ds_lint_migrator')) {
        continue;
      }

      final result = await context.currentSession.getResolvedUnit(path);
      if (result is! ResolvedUnitResult) continue;

      final visitor = _DsV3ApiVisitor();
      result.unit.accept(visitor);
      if (visitor.edits.isEmpty) continue;

      visitor.edits.sort((a, b) => b.offset.compareTo(a.offset));
      var content = result.content;
      for (final edit in visitor.edits) {
        content = content.replaceRange(edit.offset, edit.end, edit.replacement);
      }
      File(path).writeAsStringSync(content);
      filesChanged++;
      sitesFixed += visitor.sitesFixed;
      stdout.writeln(
        '  ✓ ${p.relative(path, from: repoRoot)} (${visitor.sitesFixed} sitio(s))',
      );
    }
  }

  await collection.dispose();

  stdout.writeln(
    'migrate_workspace: $sitesFixed sitio(s) migrado(s) '
    '(DsTextField.hintText → placeholder, DsBadge.color → variant) '
    'en $filesChanged archivo(s).',
  );
}

class _Edit {
  _Edit(this.offset, this.end, this.replacement);

  final int offset;
  final int end;
  final String replacement;
}

class _DsV3ApiVisitor extends RecursiveAstVisitor<void> {
  final edits = <_Edit>[];
  var sitesFixed = 0;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final typeName = node.constructorName.type.name2.lexeme;

    if (typeName == 'DsBadge') {
      for (final arg in node.argumentList.arguments) {
        if (arg is! NamedExpression || arg.name.label.name != 'color') continue;

        edits.add(_Edit(arg.name.label.offset, arg.name.label.end, 'variant'));

        final value = arg.expression;
        if (value is PrefixedIdentifier && value.prefix.name == 'DsBadgeColor') {
          edits.add(_Edit(value.prefix.offset, value.prefix.end, 'DsBadgeVariant'));
          final renamed = _valueRenames[value.identifier.name];
          if (renamed != null) {
            edits.add(_Edit(value.identifier.offset, value.identifier.end, renamed));
          }
        }
        sitesFixed++;
      }
    }

    if (typeName == 'DsTextField') {
      for (final arg in node.argumentList.arguments) {
        if (arg is! NamedExpression || arg.name.label.name != 'hintText') continue;

        edits.add(_Edit(arg.name.label.offset, arg.name.label.end, 'placeholder'));
        sitesFixed++;
      }
    }

    super.visitInstanceCreationExpression(node);
  }
}
