import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/dialogs/add_task_dialog.dart';

class SearchBarAndAddTaskButton extends StatefulWidget {
  const SearchBarAndAddTaskButton({super.key});

  @override
  _SearchBarAndAddTaskButtonState createState() =>
      _SearchBarAndAddTaskButtonState();
}

class _SearchBarAndAddTaskButtonState
    extends State<SearchBarAndAddTaskButton> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      final query = searchController.text;
      if (query.isNotEmpty) {
        context.read<TaskBloc>().add(SearchTasks(query: query));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKey,
      child: SizedBox(
        width: 450,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'backoffice_task_search_task'.tr(),
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context
                              .read<TaskBloc>()
                              .add(LoadTasks());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final query = searchController.text;
                          if (query.isNotEmpty) {
                            context
                                .read<TaskBloc>()
                                .add(SearchTasks(query: query));
                          }
                        },
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () {
                showAddTaskDialog(context);
              },
              child: Text('backoffice_task_add_task'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
