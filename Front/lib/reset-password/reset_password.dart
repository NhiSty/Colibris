import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/reset-password/reset_password_bloc.dart';
import 'package:front/validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

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
    return BlocProvider(
      create: (_) => ResetPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mot de passe oublié'),
          backgroundColor: Colors.green,
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
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  } else if (state is ResetPasswordEmailSent) {
                    setState(() {
                      _isEmailSent = true;
                    });
                  } else if (state is ResetPasswordCodeVerified) {
                    Navigator.pushNamed(context, '/reset-password-form',
                        arguments: state.code);
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
                        const Text(
                          'Colibri',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/images/login_page.png',
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 20),
                        if (state is ResetPasswordInitial ||
                            state is ResetPasswordEmailSent) ...[
                          const Text(
                            'Indiquez votre mail pour réinitialiser votre mot de passe',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          buildTextFormField(
                            _emailController,
                            Validators.validateEmail,
                            'Email',
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
                                                _emailController.text.trim()),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Envoyer un mail'),
                          ),
                        ],
                        if (state is ResetPasswordEmailSent) ...[
                          const SizedBox(height: 20),
                          const Text(
                            'Code reçu par mail',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          buildTextFormField(
                            _codeController,
                            Validators.validateEmailCode,
                            'Code',
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
                                  const SnackBar(
                                    content: Text('Code invalide'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Submit'),
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
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
    );
  }
}
