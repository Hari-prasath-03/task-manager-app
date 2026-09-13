import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/utils.dart';
import 'package:task_manager/core/widgets/keyboard_safe_scroll.dart';
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
    // Add task logic here
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
      body: KeyboardSafeScroll(
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
      ),
    );
  }
}
