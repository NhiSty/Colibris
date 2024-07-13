import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_state.dart';
import 'package:front/website/pages/backoffice/tasks/components/task_list.dart';
import 'package:front/website/pages/backoffice/tasks/components/pagination_controls.dart';
import 'package:front/website/pages/backoffice/tasks/components/title_and_breadcrumb.dart';

class TaskHandlePage extends StatelessWidget {
  const TaskHandlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TitleAndBreadcrumb(),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                print('TaskLoading');
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child:
                              TaskList(tasks: state.tasks)),
                      PaginationControls(
                        currentPage: state.currentPage,
                        totalTasks: state.totalTasks,
                        showPagination: state.showPagination,
                      ),
                    ],
                  ),
                );
              } else if (state is TaskError) {
                return Center(child: Text(state.message));
              } else if (state is TaskSearchEmpty) {
                return Center(
                    child: Text(
                        'backoffice_task_task_not_found_after_search'
                            .tr()));
              } else {
                return Center(
                    child: Text('backoffice_task_no_task'.tr()));
              }
            },
          ),
        ],
      ),
    );
  }
}
