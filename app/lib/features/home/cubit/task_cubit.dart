import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/home/data/repository/task_remote_repository.dart';
import 'package:task_manager/features/home/domain/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRemoteRepository _taskRemoteRepository;

  TaskCubit({required this._taskRemoteRepository}) : super(TaskInitial());

  Future<void> addTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueDate,
  }) async {
    emit(TaskLoading());

    try {
      final task = await _taskRemoteRepository.addTask(
        title: title,
        description: description,
        hexColor: hexColor,
        dueDate: dueDate,
      );
      emit(AddTaskSuccess(task));
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> getTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await _taskRemoteRepository.getTasks();
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TaskError('Failed to fetch tasks: $e'));
    }
  }
}
