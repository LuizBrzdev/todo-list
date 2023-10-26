import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_list_cubit/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Shoud be test E2E in Board Page ',
    () {
      testWidgets(
        'Shoud be add a new Task called Nova Tarefa',
        (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('FloatingActionButton')));
          await tester.pumpAndSettle();
          await tester.enterText(find.byKey(const Key('TextInput')), 'Nova Tarefa');
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('TapConfirm')));
          await tester.pumpAndSettle();

          final ListView taskList =
              find.byKey(const Key('GettedBoardState')).evaluate().single.widget as ListView;
          final Text taskDescription = find.text("Nova Tarefa").evaluate().single.widget as Text;

          expect(taskList.semanticChildCount, 1);
          expect(taskDescription.data, equals('Nova Tarefa'));
        },
      );
    },
  );
}
