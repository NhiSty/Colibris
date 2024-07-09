import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_state.dart';
import 'package:front/website/pages/backoffice/colocations/components/colocation_list.dart';
import 'package:front/website/pages/backoffice/colocations/components/pagination_controls.dart';

import 'chats/title_and_breadcrumb.dart';

class ConversationHandlePage extends StatelessWidget {
  const ConversationHandlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TitleAndBreadcrumb(),
          BlocBuilder<ColocationBloc, ColocationState>(
            builder: (context, state) {
              if (state is ColocationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ColocationLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child:
                              ColocationList(colocations: state.colocations)),
                      PaginationControls(
                        currentPage: state.currentPage,
                        totalColocations: state.totalColocations,
                        showPagination: state.showPagination,
                      ),
                    ],
                  ),
                );
              } else if (state is ColocationError) {
                return Center(child: Text(state.message));
              } else if (state is ColocationSearchEmpty) {
                return Center(
                    child: Text(
                        'backoffice_colocation_colocation_not_found_after_search'
                            .tr()));
              } else {
                return Center(
                    child: Text('backoffice_colocation_no_colocation'.tr()));
              }
            },
          ),
        ],
      ),
    );
  }
}
