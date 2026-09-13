import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/extension.dart';
import 'package:task_manager/features/home/presentation/pages/add_new_task_page.dart';
import 'package:task_manager/features/home/presentation/widgets/date_selector.dart';
import 'package:task_manager/features/home/presentation/widgets/task_card.dart';
import 'package:task_manager/themes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: SafeArea(
        child: Column(
          children: [
            DateSelector(),
            Row(
              children: [
                Expanded(
                  child: TaskCard(
                    color: AppColors.primaryMuted,
                    title: 'Task 1',
                    description: 'This is the first task',
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

                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("10:00 PM", style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
