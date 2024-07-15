import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/website/pages/backoffice/votes/components/add_vote_button.dart';
import 'package:go_router/go_router.dart';

class TitleAndBreadcrumb extends StatelessWidget {
  final int taskId;
  const TitleAndBreadcrumb({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(
          'backoffice_vote_title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
                context.pop();
              },
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'home'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'backoffice_task_breadcrumb'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(
              'backoffice_vote_breadcrumb'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Center(
          child: AddVoteButton(
            taskId: taskId,
          ),
        ),
      ],
    );
  }
}
