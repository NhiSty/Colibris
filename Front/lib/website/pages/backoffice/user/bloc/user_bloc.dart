import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/auth/auth_service.dart';
import 'package:front/services/user_service.dart';

import 'user_state.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userService.getAllUsers(
          page: event.page,
          pageSize: event.pageSize,
        );
        final users = response.users;
        final totalUsers = response.total;
        emit(UserLoaded(
          users: users,
          currentPage: event.page,
          totalUsers: totalUsers,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('LoadUsers error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });

    on<SearchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await userService.searchUsers(query: event.query);
        emit(UserLoaded(
          users: users,
          currentPage: 1,
          totalUsers: users.length,
          showPagination: false,
        ));
      } catch (e, stacktrace) {
        print('SearchUsers error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });

    on<ClearSearch>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userService.getAllUsers();
        final users = response.users;
        final totalUsers = response.total;
        emit(UserLoaded(
          users: users,
          currentPage: 1,
          totalUsers: totalUsers,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('ClearSearch error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });

    on<AddUser>((event, emit) async {
      emit(UserLoading());
      try {
        await register(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
        );
        final response = await userService.getAllUsers();
        final users = response.users;
        final totalUsers = response.total;
        emit(UserLoaded(
          users: users,
          currentPage: 1,
          totalUsers: totalUsers,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('AddUser error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });

    on<EditUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userService.updateUser(
          int.parse(event.id),
          {
            'firstname': event.firstName,
            'lastname': event.lastName,
          },
        );
        final response = await userService.getAllUsers();
        final users = response.users;
        final totalUsers = response.total;
        emit(UserLoaded(
          users: users,
          currentPage: 1,
          totalUsers: totalUsers,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('EditUser error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userService.deleteUser(int.parse(event.id));
        final response = await userService.getAllUsers();
        final users = response.users;
        final totalUsers = response.total;
        emit(UserLoaded(
          users: users,
          currentPage: 1,
          totalUsers: totalUsers,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('DeleteUser error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserError(message: e.toString()));
      }
    });
  }
}
