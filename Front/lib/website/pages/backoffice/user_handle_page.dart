import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:front/website/pages/backoffice/user/components/pagination_controls.dart';
import 'package:front/website/pages/backoffice/user/components/title_and_breadcrumb.dart';
import 'package:front/website/pages/backoffice/user/components/user_list.dart';

class UserHandlePage extends StatelessWidget {
  const UserHandlePage({super.key});

  static const routeName = "/backoffice/user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TitleAndBreadcrumb(),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(child: UserList(users: state.users)),
                      PaginationControls(
                        currentPage: state.currentPage,
                        totalUsers: state.totalUsers,
                        showPagination: state.showPagination,
                      ),
                    ],
                  ),
                );
              } else if (state is UserError) {
                return Center(child: Text(state.message));
              } else if (state is UserSearchEmpty) {
                return Center(
                    child: Text(
                        'backoffice_users_user_not_found_after_search'.tr()));
              } else {
                return Center(child: Text('backoffice_users_no_user'.tr()));
              }
            },
          ),
        ],
      ),
    );
  }
}
