import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_cubit/src/home/cubit/cubits/board_cubit.dart';
import 'package:todo_list_cubit/src/home/models/task.dart';
import 'package:todo_list_cubit/src/home/pages/board_page.dart';
import 'package:todo_list_cubit/src/home/repositories/board_repository.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository;
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });
  testWidgets(
    'board page with all tasks ...',
    (tester) async {
      when(() => repository.fetch()).thenAnswer(
        (invocation) async => [
          const Task(
            id: 1,
            description: 'description',
            check: false,
          )
        ],
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: const MaterialApp(
            home: BoardPage(),
          ),
        ),
      );
      expect(find.byKey(const Key('EmptyState')), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('GettedBoardState')), findsOneWidget);
    },
  );

  testWidgets(
    'board page with failure state ...',
    (tester) async {
      when(() => repository.fetch()).thenThrow((invocation) async => Exception('Error'));
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: const MaterialApp(
            home: BoardPage(),
          ),
        ),
      );
      expect(find.byKey(const Key('EmptyState')), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byKey(const Key('FailureBoardState')), findsOneWidget);
    },
  );
}
