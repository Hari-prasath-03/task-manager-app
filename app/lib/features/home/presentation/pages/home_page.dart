import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/extension.dart';
import 'package:task_manager/features/home/cubit/task_cubit.dart';
import 'package:task_manager/features/home/presentation/pages/add_new_task_page.dart';
import 'package:task_manager/features/home/presentation/widgets/date_selector.dart';
import 'package:task_manager/features/home/presentation/widgets/task_card.dart';
import 'package:task_manager/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              context.navigator.push(const AddNewTaskPage());
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else if (state is GetTasksSuccess) {
            final tasks = state.tasks
                .where((el) => DateUtils.isSameDay(el.dueDate, selectedDate))
                .toList();
            return Column(
              children: [
                DateSelector(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                              color: task.color,
                              title: task.title,
                              description: task.description,
                            ),
                          ),

                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              DateFormat.jm()
                                  .format(task.dueDate)
                                  .padLeft(8, '0'),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Something suspecious."));
        },
      ),
    );
  }
}
