import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/dialogs/users/add_user_dialog.dart';

class SearchBarAndAddUserButton extends StatefulWidget {
  const SearchBarAndAddUserButton({super.key});

  @override
  _SearchBarAndAddUserButtonState createState() =>
      _SearchBarAndAddUserButtonState();
}

class _SearchBarAndAddUserButtonState extends State<SearchBarAndAddUserButton> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'backoffice_users_search'.tr(),
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        context.read<UserBloc>().add(ClearSearch());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final query = searchController.text;
                        if (query.isNotEmpty) {
                          context
                              .read<UserBloc>()
                              .add(SearchUsers(query: query));
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
              showAddUserDialog(context);
            },
            child: Text('backoffice_users_add_user'.tr()),
          ),
        ],
      ),
    );
  }
}
