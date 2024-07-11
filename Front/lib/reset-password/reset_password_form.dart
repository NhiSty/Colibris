import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/reset-password/reset_password_bloc.dart';
import 'package:front/main.dart';

class ResetPasswordFormScreen extends StatelessWidget {
  ResetPasswordFormScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String emailCode =
    ModalRoute.of(context)?.settings.arguments as String;

    return SafeArea(
      child: BlocProvider(
        create: (_) => ResetPasswordBloc(),
        child: GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('forget_password_change_title'.tr()),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
              ),
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
                          SnackBar(content: Text(state.message)),
                        );
                      } else if (state is ResetPasswordEmailSent) {
                        Navigator.pushNamed(context, '/login');
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
                            buildTextFormField(
                              _passwordController,
                              'forget_password_change_new_password'.tr(),
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              _passwordConfirmController,
                              'forget_password_change_confirm_password'.tr(),
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _resetPassword(context, emailCode);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey,
                              ),
                              child:
                              Text('forget_password_change_submit'.tr()),
                            ),
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
      String label, {
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
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
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label invalide';
        }
        if (label == 'forget_password_change_confirm_password'.tr() &&
            value != _passwordController.text) {
          return 'forget_password_pwd_not_match'.tr();
        }
        return null;
      },
    );
  }

  void _resetPassword(BuildContext context, String emailCode) {
    context.read<ResetPasswordBloc>().add(
      ResetPasswordWithEmailCode(
        email: _passwordController.text.trim(),
        code: emailCode,
      ),
    );
  }
}
