// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list_cubit/src/home/models/task.dart';

sealed class BoardState {}

class LoadingBordState implements BoardState {}

class GettedTaskBoardState implements BoardState {
  final List<Task> tasks;

  GettedTaskBoardState({
    required this.tasks,
  });
}

class EmptyBoardState extends GettedTaskBoardState {
  EmptyBoardState() : super(tasks: []);
}

class FailureBoardState implements BoardState {
  final String message;
  FailureBoardState({
    required this.message,
  });
}
