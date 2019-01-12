import '../model/todo.dart';

class MainState {
  List<Todo> todos;

  MainState(this.todos);

  factory MainState.init() {
    return MainState(List());
  }
}

