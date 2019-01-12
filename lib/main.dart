import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'components/add_task_screen.dart';
import 'components/to_do_list.dart';
import 'reducers/main_state.dart';
import 'reducers/root_reducer.dart';
import 'utils/database_helper.dart';

void main() async {
  var db = DatabaseHelper();
  var todo = await db.getAllTodos();
  final store = Store<MainState>(
      rootReducer,
      initialState: MainState(todo),
      middleware: [thunkMiddleware]
  );
  runApp(FlutterReduxApp(title: 'ToDo', store: store));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<MainState> store;
  final String title;

  FlutterReduxApp({Key key, this.store, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: title,
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: Home(title),
        ));
  }
}

class Home extends StatelessWidget {
  final String title;

  Home(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskScreen())),
        backgroundColor: Colors.red,
        child: Icon(Icons.assignment),
      ),
    );
  }
}
