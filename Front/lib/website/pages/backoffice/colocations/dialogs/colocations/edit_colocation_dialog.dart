import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_state.dart';
import 'package:front/website/share/custom_dialog.dart';

void showEditColocationDialog(BuildContext context, Colocation coloc) {
  final _nameController = TextEditingController();
  _nameController.text = coloc.name;
  final _descriptionController = TextEditingController();
  _descriptionController.text = coloc.description ?? '';
  bool isPermanent = coloc.isPermanent;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<ColocationBloc>(context),
        child: BlocListener<ColocationBloc, ColocationState>(
          listener: (context, state) {
            if (state is ColocationLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('update_colocation_updated_successfully'.tr()),
                ),
              ));
              Navigator.pop(context);
            } else if (state is ColocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('update_colocation_updated_error'.tr()),
                ),
              ));
            }
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CustomDialog(
                title: 'update_colocation_title'.tr(),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'update_colocation_name'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'update_colocation_description'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text('update_colocation_permanently'.tr()),
                      value: isPermanent,
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        setState(() {
                          isPermanent = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel'.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        context.read<ColocationBloc>().add(EditColocation(
                              id: coloc.id,
                              name: _nameController.text,
                              description: _descriptionController.text,
                              isPermanent: isPermanent,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('fill_all_fields'.tr()),
                          ),
                        ));
                      }
                    },
                    child: Text('save'.tr()),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
