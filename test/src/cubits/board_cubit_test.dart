import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_cubit/src/home/cubit/cubits/board_cubit.dart';
import 'package:todo_list_cubit/src/home/cubit/states/board_state.dart';

import 'package:mocktail/mocktail.dart';
import 'package:todo_list_cubit/src/home/models/task.dart';
import 'package:todo_list_cubit/src/home/repositories/board_repository.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  // final repository = BoardRepositoryMock();
  // final cubit = BoardCubit(repository);
  // tearDown(() => reset(repository));
  late BoardRepositoryMock repository;
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group(
    'fetchTasks ||',
    () {
      test(
        'Should be get all tasks',
        () async {
          when(() => repository.fetch()).thenAnswer(
            (_) async => [
              const Task(
                id: 1,
                description: 'description',
                check: false,
              )
            ],
          );

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<LoadingBordState>(),
                isA<GettedTaskBoardState>(),
              ],
            ),
          );
          await cubit.fetchTasks();
        },
      );
      test(
        'Shoud be show a error message',
        () async {
          when(() => repository.fetch()).thenThrow(Exception('error'));
          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<LoadingBordState>(),
                isA<FailureBoardState>(),
              ],
            ),
          );
          await cubit.fetchTasks();
        },
      );
    },
  );

  group(
    'update Task ||',
    () {
      const task = Task(id: 1, description: '', check: false);
      test(
        'Should be update a task',
        () async {
          when(() => repository.update(any())).thenAnswer(
            (_) async => [],
          );

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTaskBoardState>(),
              ],
            ),
          );

          await cubit.addTask();
          final state = cubit.state as GettedTaskBoardState;
          expect(state.tasks.length, 1);
          expect(state.tasks, [task]);
        },
      );
      test(
        'Should be fail in update  task',
        () async {
          when(() => repository.update(any())).thenThrow(
            (_) => Exception('error'),
          );

          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );

          await cubit.addTask();
        },
      );
    },
  );

  group(
    'remove Task ||',
    () {
      const task = Task(id: 1, description: 'description', check: false);
      test(
        'Should be remove a task',
        () async {
          when(() => repository.update(any())).thenAnswer((_) async => []);
          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTaskBoardState>(),
              ],
            ),
          );

          cubit.addTasks([task]);
          expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
          await cubit.removeTask(task);
          final state = cubit.state as GettedTaskBoardState;
          expect(state.tasks.length, 0);
        },
      );
      test(
        'Should be fail in remove task',
        () async {
          when(() => repository.update(any())).thenThrow(
            (_) => Exception('error'),
          );
          cubit.addTasks([task]);
          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );
          await cubit.removeTask(task);
        },
      );
    },
  );

  group(
    'check Task ||',
    () {
      const task = Task(id: 1, description: 'description', check: false);
      test(
        'Should be check a Task',
        () async {
          when(() => repository.update(any())).thenAnswer((_) async => []);
          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<GettedTaskBoardState>(),
              ],
            ),
          );

          cubit.addTasks([task]);
          expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);
          await cubit.checkTask(task);
          final state = cubit.state as GettedTaskBoardState;
          expect(state.tasks.length, 1);
          expect(state.tasks.first.check, true);
        },
      );
      test(
        'Should be fail in check task',
        () async {
          when(() => repository.update(any())).thenThrow(
            (_) => Exception('error'),
          );
          cubit.addTasks([task]);
          expect(
            cubit.stream,
            emitsInOrder(
              [
                isA<FailureBoardState>(),
              ],
            ),
          );
          await cubit.checkTask(task);
        },
      );
    },
  );
}
