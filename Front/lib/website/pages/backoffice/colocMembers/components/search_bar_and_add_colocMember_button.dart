import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/dialogs/colocMembers/add_coloc_member_dialog.dart';

class SearchBarAndAddColocMemberButton extends StatefulWidget {
  const SearchBarAndAddColocMemberButton({super.key});

  @override
  _SearchBarAndAddColocMemberButtonState createState() =>
      _SearchBarAndAddColocMemberButtonState();
}

class _SearchBarAndAddColocMemberButtonState
    extends State<SearchBarAndAddColocMemberButton> {
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
        context.read<ColocMemberBloc>().add(SearchColocMembers(query: query));
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
                  hintText: 'backoffice_colocMember_search_coloc_members'.tr(),
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context
                              .read<ColocMemberBloc>()
                              .add(LoadColocMembers());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final query = searchController.text;
                          if (query.isNotEmpty) {
                            context
                                .read<ColocMemberBloc>()
                                .add(SearchColocMembers(query: query));
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
                showAddColocMemberDialog(context);
              },
              child: Text('backoffice_colocMember_add_coloc_member'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
