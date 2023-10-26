import 'package:todo_list_cubit/src/home/models/task.dart';

abstract class BoardRepository {
  Future<List<Task>> fetch();

  Future<List<Task>> update(List<Task> tasks);
}
