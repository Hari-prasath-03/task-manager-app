import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/utils.dart';
import 'package:task_manager/core/widgets/keyboard_safe_scroll.dart';
import 'package:task_manager/extension.dart';
import 'package:task_manager/features/home/cubit/task_cubit.dart';
import 'package:task_manager/features/home/presentation/pages/home_page.dart';
import 'package:task_manager/themes.dart';

class AddNewTaskPage extends StatefulWidget {
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  DateTime selectedDate = DateTime.now();
  Color selectedColor = AppColors.primaryMuted;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void addTask() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TaskCubit>().addTask(
      title: titleController.text,
      description: descriptionController.text,
      hexColor: rgbToHex(selectedColor),
      dueDate: selectedDate,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task', style: TextStyle(fontSize: 18)),
        actions: [
          GestureDetector(
            onTap: () async {
              final currSelectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                initialDate: selectedDate,
              );

              if (currSelectedDate != null) {
                setState(() {
                  selectedDate = currSelectedDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(DateFormat('MMM d, yyyy').format(selectedDate)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AddTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task added successfully!')),
            );
            context.navigator.pushAndRemoveUntil(const HomePage());
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return KeyboardSafeScroll(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Task Title'),
                      controller: titleController,
                      validator: (value) => validateField(value),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Task description',
                      ),
                      controller: descriptionController,
                      validator: (value) => validateField(value),
                    ),
                    const SizedBox(height: 10),
                    ColorPicker(
                      heading: const Text('Pick a color'),
                      subheading: const Text('Select a different shade'),
                      padding: EdgeInsets.all(0),
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      color: selectedColor,
                      pickersEnabled: const {ColorPickerType.wheel: true},
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addTask,
                      child: const Text(
                        'Add Task',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
