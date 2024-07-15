import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/colocation/colocation.dart';
import 'package:colibris/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:colibris/website/pages/backoffice/colocations/bloc/colocation_state.dart';
import 'package:colibris/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showDeleteColocationDialog(BuildContext context, Colocation coloc) {
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
                  child:
                      Text('backoffice_colocation_deleted_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is ColocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_colocation_deleted_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_colocation_delete_modal_title'.tr(),
            height: 50.0,
            width: 150.0,
            content: Text('backoffice_colocation_delete_modal_confirm'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<ColocationBloc>()
                      .add(DeleteColocation(id: coloc.id));
                },
                child: Text('delete'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
