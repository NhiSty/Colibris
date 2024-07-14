import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showAddColocMemberDialog(BuildContext context) {
  context.read<ColocMemberBloc>().add(LoadAllUsersAndColocations());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<ColocMemberBloc>(context),
        child: const AddColocMemberDialog(),
      );
    },
  ).then((_) {
    context.read<ColocMemberBloc>().add(LoadColocMembers());
  });
}

class AddColocMemberDialog extends StatefulWidget {
  const AddColocMemberDialog({super.key});

  @override
  _AddColocMemberDialogState createState() => _AddColocMemberDialogState();
}

class _AddColocMemberDialogState extends State<AddColocMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUserId;
  String? _selectedColocationId;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'backoffice_colocMember_add_coloc_member'.tr(),
      width: 400.0,
      height: 200.0,
      content: BlocListener<ColocMemberBloc, ColocMemberState>(
        listener: (context, state) {
          if (state is ColocMemberAdded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ));
            context.pop();
          } else if (state is ColocMemberError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Form(
          key: _formKey,
          child: BlocBuilder<ColocMemberBloc, ColocMemberState>(
            builder: (context, state) {
              if (state is UsersAndColocationsLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedUserId,
                      hint: Text(
                          'backoffice_colocMember_select_user_in_add_modal'
                              .tr()),
                      onChanged: (value) {
                        setState(() {
                          _selectedUserId = value;
                        });
                      },
                      items: state.users
                          .map((user) => DropdownMenuItem<String>(
                                value: user.id.toString(),
                                child:
                                    Text('${user.firstname} ${user.lastname}'),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a user';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedColocationId,
                      hint: Text(
                          'backoffice_colocMember_select_colocation_in_add_modal'
                              .tr()),
                      onChanged: (value) {
                        setState(() {
                          _selectedColocationId = value;
                        });
                      },
                      items: state.colocations
                          .map((coloc) => DropdownMenuItem<String>(
                                value: coloc['ID'].toString(),
                                child: Text(coloc['Name']),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a colocation';
                        }
                        return null;
                      },
                    ),
                  ],
                );
              } else if (state is UsersAndColocationsLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(child: Text('Loading...'));
              }
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final int userId = int.parse(_selectedUserId!);
              final int colocationId = int.parse(_selectedColocationId!);

              context.read<ColocMemberBloc>().add(AddColocMember(
                    userId: userId,
                    colocationId: colocationId,
                  ));
            }
          },
          child: Text('save'.tr()),
        ),
      ],
    );
  }
}
