import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:front/website/share/custom_dialog.dart';

void showEditColocMemberDialog(
    BuildContext context, int colocMemberId, double score) {
  TextEditingController newScoreController =
      TextEditingController(text: score.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<ColocMemberBloc>(context),
        child: BlocListener<ColocMemberBloc, ColocMemberState>(
          listener: (context, state) {
            if (state is ColocMemberLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      'backoffice_colocMember_score_updated_successfully'.tr()),
                ),
              ));
              Navigator.pop(context);
            } else if (state is ColocMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Text('backoffice_colocMember_score_updated_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_colocMember_update_user'.tr(),
            height: 100.0,
            width: 250.0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newScoreController,
                  decoration: const InputDecoration(labelText: 'Score'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                  if (newScoreController.text.isNotEmpty) {
                    if (int.parse(newScoreController.text) > 0) {
                      context
                          .read<ColocMemberBloc>()
                          .add(UpdateColocMemberScore(
                            colocMemberId: colocMemberId,
                            newScore: int.parse(newScoreController.text),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('score_must_be_positive'.tr()),
                        ),
                      ));
                    }
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
          ),
        ),
      );
    },
  );
}
