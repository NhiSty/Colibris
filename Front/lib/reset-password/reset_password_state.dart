part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordEmailSent extends ResetPasswordState {}

class ResetPasswordCodeVerified extends ResetPasswordState {
  final String code;
  ResetPasswordCodeVerified({required this.code});
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}
