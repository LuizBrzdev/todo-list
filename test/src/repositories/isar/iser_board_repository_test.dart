import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_cubit/src/home/models/task.dart';
import 'package:todo_list_cubit/src/home/repositories/board_repository.dart';
import 'package:todo_list_cubit/src/home/repositories/isar/isar_board_repository.dart';
import 'package:todo_list_cubit/src/home/repositories/isar/isar_datasource.dart';
import 'package:todo_list_cubit/src/home/repositories/isar/task_model.dart';

class IsarDataSourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource;
  late BoardRepository boardRepository;
  setUp(() {
    datasource = IsarDataSourceMock();
    boardRepository = IsarBoardRepository(datasource);
  });
  group('Fetch ||', () {
    test(
      'Should be test fetch repository',
      () async {
        when(() => datasource.getTasks()).thenAnswer(
          (_) async => [
            TaskModel()..id = 1,
          ],
        );
        final tasks = await boardRepository.fetch();
        expect(tasks.length, 1);
      },
    );

    test(
      'Should be test delete and put repository',
      () async {
        when(() => datasource.deleteAllTasks()).thenAnswer(
          (_) async => [],
        );
        when(() => datasource.putAllTasks(any())).thenAnswer(
          (_) async => [],
        );
        final tasks = await boardRepository.update(
          [
            const Task(id: -1, description: 'description', check: false),
            const Task(id: 2, description: 'description', check: false),
          ],
        );
        expect(tasks.length, 2);
      },
    );
  });
}
