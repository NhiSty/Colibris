import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/reset-password/reset_password_bloc.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
import 'package:front/reset-password/reset_password_form.dart';
import 'package:front/validators.dart';
import 'package:front/main.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static const routeName = "/reset-password";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isEmailSent = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => ResetPasswordBloc(),
        child: GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('forget_password_title'.tr()),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                    listener: (context, state) {
                      if (state is ResetPasswordError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBarFeedback(
                            state.message,
                            Colors.red,
                          ),
                        );

                        context.go('/login');
                      } else if (state is ResetPasswordEmailSent) {
                        setState(() {
                          _isEmailSent = true;
                        });
                      } else if (state is ResetPasswordCodeVerified) {
                        context.go(
                          ResetPasswordFormScreen.routeName,
                          extra: {'emailCode': state.code},
                        );

                      }
                    },
                    builder: (context, state) {
                      if (state is ResetPasswordLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/login_page.png',
                              height: 200,
                              width: 200,
                            ),
                            const SizedBox(height: 20),
                            if (state is ResetPasswordInitial ||
                                state is ResetPasswordEmailSent) ...[
                              Text(
                                'forget_password_text'.tr(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              buildTextFormField(
                                _emailController,
                                Validators.validateEmail,
                                'forget_password_email'.tr(),
                                enabled: !_isEmailSent,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isEmailSent
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ResetPasswordBloc>().add(
                                      SendResetEmail(
                                          _emailController.text
                                              .trim()),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey[800],
                                ),
                                child: Text('forget_password_submit'.tr()),
                              ),
                            ],
                            if (state is ResetPasswordEmailSent) ...[
                              const SizedBox(height: 20),
                              Text(
                                'forget_password_received_code_by_mail'.tr(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              buildTextFormField(
                                _codeController,
                                Validators.validateEmailCode,
                                'forget_password_code'.tr(),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ResetPasswordBloc>().add(
                                      VerifyResetCode(
                                          _codeController.text.trim()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      showSnackBarFeedback(
                                        'forget_password_code_invalid'.tr(),
                                        Color(0xFFD00000),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: Text('forget_password_submit_code'.tr()),
                              ),
                            ],
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller,
      String? Function(String?)? validator,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
        bool enabled = true,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorStyle: TextStyle(color: Color(0xFFD00000), fontSize: 15),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
    );
  }
}
