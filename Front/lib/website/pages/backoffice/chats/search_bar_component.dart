import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';

class SearchBarComponent extends StatefulWidget {
  const SearchBarComponent({Key? key}) : super(key: key);

  @override
  _SearchBarComponentState createState() =>
      _SearchBarComponentState();
}

class _SearchBarComponentState
    extends State<SearchBarComponent> {
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
        context.read<ColocationBloc>().add(SearchColocations(query: query));
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
                  hintText: 'backoffice_chat_search'.tr(),
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<ColocationBloc>().add(ClearSearch());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final query = searchController.text;
                          if (query.isNotEmpty) {
                            context
                                .read<ColocationBloc>()
                                .add(SearchColocations(query: query));
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
          ],
        ),
      ),
    );
  }
}
