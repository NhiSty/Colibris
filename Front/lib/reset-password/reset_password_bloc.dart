import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/auth/auth_service.dart';

part 'package:front/reset-password/reset_password_event.dart';
part 'package:front/reset-password/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<SendResetEmail>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        await resetPassword(event.email);
        emit(ResetPasswordEmailSent());
      } catch (e) {
        emit(ResetPasswordError(e.toString()));
      }
    });

    on<VerifyResetCode>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        final statusCode = await checkConfirmationCode(event.code);
        if (statusCode == 200) {
          emit(ResetPasswordCodeVerified(code: event.code));
        } else {
          emit(ResetPasswordError('Invalid code'));
        }
      } catch (e) {
        emit(ResetPasswordError(e.toString()));
      }
    });

    on<ResetPasswordWithEmailCode>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        await resetPasswordWithCode(event.pwd, event.code);
        emit(ResetPasswordEmailSent());
      } catch (e) {
        emit(ResetPasswordError(e.toString()));
      }
    });
  }
}
