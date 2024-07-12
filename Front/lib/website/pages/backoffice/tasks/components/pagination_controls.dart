import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalTasks;
  final int pageSize;
  final bool showPagination;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalTasks,
    this.pageSize = 5,
    this.showPagination = true,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalTasks / pageSize).ceil();

    if (!showPagination) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1
                ? () {
                    context
                        .read<TaskBloc>()
                        .add(LoadTasks(page: 1, pageSize: pageSize));
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: currentPage > 1
                ? () {
                    context.read<TaskBloc>().add(LoadTasks(
                        page: currentPage - 1, pageSize: pageSize));
                  }
                : null,
          ),
          Text('$currentPage / $totalPages'),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: currentPage < totalPages
                ? () {
                    context.read<TaskBloc>().add(LoadTasks(
                        page: currentPage + 1, pageSize: pageSize));
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < totalPages
                ? () {
                    context.read<TaskBloc>().add(
                        LoadTasks(page: totalPages, pageSize: pageSize));
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
