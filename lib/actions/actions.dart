import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:reminder/reducers/main_state.dart';
import 'package:reminder/utils/database_helper.dart';

import '../model/todo.dart';

class AddTaskFinishedAction {
  final Todo task;

  AddTaskFinishedAction(this.task);
}

class RemoveTaskAction {
  final Todo todo;

  RemoveTaskAction(this.todo);
}

class ToggleTaskStateAction {
  final Todo todo;

  ToggleTaskStateAction(this.todo);
}

ThunkAction<MainState> addTaskThunkAction(Todo task) {
  return (Store<MainState> store) async {
    try {
      var db = DatabaseHelper();
      var result = await db.saveTodo(task);
      task.id = result;
      store.dispatch(AddTaskFinishedAction(task));
    } catch (e, stacktrace) {
      print("Error: $e\n$stacktrace");
    }
  };
}


ThunkAction<MainState> removeTaskThunkAction(Todo task) {
  return (Store<MainState> store) async {
    try {
      var db = DatabaseHelper();
      await db.removeTodo(task);
      store.dispatch(RemoveTaskAction(task));
    } catch (e, stacktrace) {
      print("Error: $e\n$stacktrace");
    }
  };
}

ThunkAction<MainState> toggleTaskFinishedThunkAction(Todo task) {
  return (Store<MainState> store) async {
    try {
      var db = DatabaseHelper();
      await db.updateTodo(task);
      store.dispatch(ToggleTaskStateAction(task));
    } catch (e, stacktrace) {
      print("Error: $e\n$stacktrace");
    }
  };
}


