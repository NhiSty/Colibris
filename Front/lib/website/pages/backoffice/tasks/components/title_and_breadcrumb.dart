import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/website/pages/backoffice/tasks/components/search_bar_and_add_task_button.dart';

class TitleAndBreadcrumb extends StatelessWidget {
  const TitleAndBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(
          'backoffice_task_title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, "/home");
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'home'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'backoffice_task_breadcrumb'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Center(
          child: SearchBarAndAddTaskButton(),
        ),
      ],
    );
  }
}
