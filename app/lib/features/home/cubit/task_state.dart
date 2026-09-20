part of 'task_cubit.dart';

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
}

final class AddTaskSuccess extends TaskState {
  final TaskModel task;
  const AddTaskSuccess(this.task);
}

final class GetTasksSuccess extends TaskState {
  final List<TaskModel> tasks;
  const GetTasksSuccess(this.tasks);
}
