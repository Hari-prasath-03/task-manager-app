import 'package:dio/dio.dart';
import 'package:task_manager/core/services/sp_service.dart';
import 'package:task_manager/features/home/data/repository/task_local_repository.dart';
import 'package:task_manager/features/home/domain/task_model.dart';

class TaskRemoteRepository {
  final Dio _dio;
  final SPService _spService;
  final TaskLocalRepository _taskLocalRepository;

  TaskRemoteRepository({
    required this._dio,
    required this._spService,
    required this._taskLocalRepository,
  });

  Future<Map<String, dynamic>> get authHeader async {
    final token = await _spService.getToken();
    return {'x-auth-token': token};
  }

  Future<TaskModel> addTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueDate,
  }) async {
    try {
      final authHeader = await this.authHeader;
      final response = await _dio.post(
        '/tasks',
        data: {
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueDate': dueDate.toIso8601String(),
        },
        options: Options(headers: authHeader),
      );

      final task = TaskModel.fromMap(response.data);
      await _taskLocalRepository.insertTask(task);

      return task;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final authHeader = await this.authHeader;
      final response = await _dio.get(
        '/tasks',
        options: Options(headers: authHeader),
      );

      final tasks = (response.data['tasks'] as List)
          .map((taskData) => TaskModel.fromMap(taskData))
          .toList();

      await _taskLocalRepository.insertTasks(tasks);
      return tasks;
    } catch (e) {
      final localTasks = await _taskLocalRepository.getTasks();
      if (localTasks.isNotEmpty) {
        return localTasks;
      } else {
        rethrow;
      }
    }
  }
}
