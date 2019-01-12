import '../actions/actions.dart';
import 'main_state.dart';

MainState rootReducer(MainState state, dynamic action) {
  // Thunk action
  if (action is MainState) return action;

  // Store action
  if (action is AddTaskFinishedAction) {
    return addItem(state, action);
  } else if (action is RemoveTaskAction) {
    return removeItem(state, action);
  } else if (action is ToggleTaskStateAction) {
    return toggleTaskState(state, action);
  }
  return state;
}

MainState addItem(MainState state, AddTaskFinishedAction action) {
  return MainState(state.todos..add(action.task));
}

MainState removeItem(MainState state, RemoveTaskAction action) {
  return MainState(state.todos.where((todo) => todo != action.todo).toList());
}

MainState toggleTaskState(MainState state, ToggleTaskStateAction action) {
  final newList = state.todos.map((todo) {
    if (todo.taskname == action.todo.taskname &&
        todo.createdTimestamp == action.todo.createdTimestamp)
      todo.changeTaskFinishedStatus(action.todo.finished);
    return todo;
  }).toList();
  return MainState(newList);
}
