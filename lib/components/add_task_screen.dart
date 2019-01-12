import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:reminder/actions/actions.dart';
import 'package:reminder/model/todo.dart';
import 'package:reminder/reducers/main_state.dart';

class AddTaskScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<MainState, _AddTaskScreenViewModel>(
        converter: (store) => _AddTaskScreenViewModel.create(store),
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Create New Task'),
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: (taskname) => vm.handleSaveTask(taskname, context),
                decoration:
                    InputDecoration.collapsed(hintText: "Enter task name"),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => vm.handleSaveTask(_controller.text, context),
              backgroundColor: Colors.red,
              child: Icon(Icons.save),
            ),
          );
        });
  }
}

class _AddTaskScreenViewModel {
  String inputtedTaskName;
  final Function saveTask;

  _AddTaskScreenViewModel({this.saveTask});

  factory _AddTaskScreenViewModel.create(Store<MainState> store) {
    return _AddTaskScreenViewModel(
        saveTask: (taskname) =>
            store.dispatch(addTaskThunkAction(Todo(taskname: taskname))));
  }

  void handleSaveTask(String taskname, BuildContext context) {
    if (taskname.isNotEmpty) {
      saveTask(taskname.trim());
      Navigator.pop(context);
    }
  }
}
