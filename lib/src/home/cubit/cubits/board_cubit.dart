import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';

import '../../repositories/board_repository.dart';
import '../states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  final TextEditingController taskDescription = TextEditingController();

  late bool canDismissTask;

  Future<void> fetchTasks() async {
    emit(LoadingBordState());
    try {
      final tasks = await repository.fetch();
      if (tasks.isEmpty) {
        emit(EmptyBoardState());
      } else {
        emit(GettedTaskBoardState(tasks: tasks));
      }
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> addTask() async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(Task(id: 1, description: taskDescription.text, check: false));
    await emitTasks(tasks);
    taskDescription.clear();
  }

  Future<void> removeTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(task);
    await emitTasks(tasks);
  }

  Future<void> checkTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(task);
    tasks[index] = task.copyWith(check: !task.check);
    await emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return null;
    }

    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      if (tasks.isEmpty) {
        emit(EmptyBoardState());
      } else {
        emit(GettedTaskBoardState(tasks: tasks));
      }
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }
}
