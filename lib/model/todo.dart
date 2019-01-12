final String tableTodo = 'todo';
final String columnId = '_id';
final String columnName = 'taskname';
final String columnType = 'type';
final String columnFinished = 'finished';
final String columnCreatedTimestamp = 'createdTimestamp';

class Todo {
  int id;
  String taskname;
  String type = 'todo';
  bool finished;
  DateTime createdTimestamp;

  Todo({this.taskname, this.finished = false, this.createdTimestamp}) {
    if (this.createdTimestamp == null) createdTimestamp = DateTime.now();
  }

  Todo copy({String task, bool finished, DateTime createdTimestamp}) {
    final temp = Todo(
        taskname: task ?? this.taskname,
        finished: finished ?? this.finished,
        createdTimestamp: createdTimestamp ?? this.createdTimestamp);
    temp.id = this.id;
    temp.type = this.type;
    return temp;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: taskname,
      columnType: type,
      columnFinished: finished == true ? 1 : 0,
      columnCreatedTimestamp: createdTimestamp.toIso8601String()
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.taskname = map[columnName];
    this.type = map[columnType];
    this.finished = map[columnFinished] == 1 ? true : false;
    this.createdTimestamp = DateTime.parse(map[columnCreatedTimestamp]);
  }

  String taskWithPadding() {
    return '  $taskname   ';
  }

  void changeTaskFinishedStatus(bool change) {
    this.finished = change;
  }
}