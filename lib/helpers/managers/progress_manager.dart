import 'package:flutter/foundation.dart';
import '../../models/download_task.dart';

class ProgressManager extends ChangeNotifier {
  final Map<String, DownloadTask> _tasks = {};

  List<DownloadTask> get tasks => _tasks.values.toList();

  void addTask(DownloadTask task) {
    _tasks[task.id] = task;
    notifyListeners();
  }

  void updateProgress(String taskId, int received, int total) {
    final task = _tasks[taskId];
    if (task != null) {
      task.receivedBytes = received;
      task.totalBytes = total;
      task.status = DownloadStatus.downloading;
      notifyListeners();
    }
  }

  void markCompleted(String taskId) {
    final task = _tasks[taskId];
    if (task != null) {
      task.status = DownloadStatus.completed;
      notifyListeners();
    }
  }

  void markFailed(String taskId, String error) {
    final task = _tasks[taskId];
    if (task != null) {
      task.status = DownloadStatus.failed;
      task.error = error;
      notifyListeners();
    }
  }

  void removeTask(String taskId) {
    _tasks.remove(taskId);
    notifyListeners();
  }
}
