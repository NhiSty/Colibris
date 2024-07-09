import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:front/website/pages/backoffice/colocMembers/components/colocMember_list.dart';
import 'package:front/website/pages/backoffice/colocMembers/components/pagination_controls.dart';
import 'package:front/website/pages/backoffice/colocMembers/components/title_and_breadcrumb.dart';

class ColocMemberHandlePage extends StatelessWidget {
  const ColocMemberHandlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TitleAndBreadcrumb(),
          Expanded(
            child: BlocBuilder<ColocMemberBloc, ColocMemberState>(
              builder: (context, state) {
                if (state is ColocMemberLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ColocMemberLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child:
                            ColocMemberList(colocMembers: state.colocMembers),
                      ),
                      PaginationControls(
                        currentPage: state.currentPage,
                        totalUsers: state.totalColocMembers,
                        showPagination: state.showPagination,
                      ),
                    ],
                  );
                } else if (state is ColocMemberError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                    child: Text('No colocations found'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
