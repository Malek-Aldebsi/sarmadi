import 'package:flutter/material.dart';

// TODO: check and clean
class TasksProvider with ChangeNotifier {
  Map _tasks = {};
  double _dailyTasksCompletionPercentage = 0;
  double _weeklyTasksCompletionPercentage = 0;

  Map get tasks => _tasks;
  double get dailyTasksCompletionPercentage => _dailyTasksCompletionPercentage;
  double get weeklyTasksCompletionPercentage =>
      _weeklyTasksCompletionPercentage;

  void setTasks(Map tasks) {
    _tasks = tasks;

    num totalTasks = _tasks.values
        .map((subject) => subject['task'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    num totalDone = _tasks.values
        .map((subject) => subject['done'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    setDailyTasksCompletionPercentage(
        totalTasks == 0 ? 0 : (100 * totalDone / totalTasks).roundToDouble());
    // TODO: setWeeklyTasksCompletionPercentage
    notifyListeners();
  }

  void editTask(String subjectName, int tasks) {
    _tasks[subjectName]['task'] += tasks;
    num totalTasks = _tasks.values
        .map((subject) => subject['task'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    num totalDone = _tasks.values
        .map((subject) => subject['done'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    setDailyTasksCompletionPercentage(
        totalTasks == 0 ? 0 : (100 * totalDone / totalTasks).roundToDouble());
    notifyListeners();
  }

  void editDoneTask(String subjectName, int done) {
    _tasks[subjectName]['done'] +=
        _tasks[subjectName]['done'] > _tasks[subjectName]['task']
            ? _tasks[subjectName]['task']
            : done;
    num totalTasks = _tasks.values
        .map((subject) => subject['task'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    num totalDone = _tasks.values
        .map((subject) => subject['done'])
        .fold(0, (previousValue, element) => previousValue + (element ?? 0));

    setDailyTasksCompletionPercentage(
        totalTasks == 0 ? 0 : (100 * totalDone / totalTasks).roundToDouble());
    notifyListeners();
  }

  void setDailyTasksCompletionPercentage(
      double dailyTasksCompletionPercentage) {
    _dailyTasksCompletionPercentage = dailyTasksCompletionPercentage;
    notifyListeners();
  }

  void setWeeklyTasksCompletionPercentage(
      double weeklyTasksCompletionPercentage) {
    _weeklyTasksCompletionPercentage = weeklyTasksCompletionPercentage;
    notifyListeners();
  }
}
