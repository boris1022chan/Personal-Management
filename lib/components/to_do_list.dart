import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:reminder/model/todo.dart';

import '../actions/actions.dart';
import '../reducers/main_state.dart';

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<MainState, _TodoViewModel>(
      converter: (store) => _TodoViewModel.create(store),
      builder: (context, _TodoViewModel vm) {
        return vm.todos.length > 0
            ? Container(
                child: ListView.separated(
                  itemCount: vm.todos.length,
                  itemBuilder: (_, i) => _buildTodoItem(vm, vm.todos[i]),
                  separatorBuilder: (_, i) => Divider(),
                ),
              )
            : _buildEmptyScreen();
      },
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.assignment, color: Colors.black12, size: 70,),
          Text("No todo has been added yet", style: TextStyle(color: Colors.black26),),
        ],
      ),
    );
  }

  Widget _buildTodoItem(_TodoViewModel vm, Todo todo) {
    return CheckboxListTile(
      value: todo.finished,
      onChanged: (b) =>
          vm.toggleTaskFinishedStatusAction(todo.copy(finished: b)),
      title: Text(
        todo.taskWithPadding(),
        style: TextStyle(
            decorationColor: Colors.black,
            decorationStyle: TextDecorationStyle.solid,
            decoration: todo.finished ? TextDecoration.lineThrough : null),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.red,
      secondary: IconButton(
          icon: Icon(Icons.clear), onPressed: () => vm.removeTaskAction(todo)),
    );
  }
}

class _TodoViewModel {
  final List<Todo> todos;
  final Function removeTaskAction;
  final Function toggleTaskFinishedStatusAction;

  _TodoViewModel(
      {this.todos, this.removeTaskAction, this.toggleTaskFinishedStatusAction});

  factory _TodoViewModel.create(Store<MainState> store) {
    return _TodoViewModel(
        todos: store.state.todos,
        removeTaskAction: (task) => store.dispatch(removeTaskThunkAction(task)),
        toggleTaskFinishedStatusAction: (task) =>
            store.dispatch(toggleTaskFinishedThunkAction(task)));
  }
}
