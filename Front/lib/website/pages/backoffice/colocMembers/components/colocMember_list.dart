import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/services/colocMember_service.dart';
import 'package:front/website/pages/backoffice/colocMembers/components/colocMember_list_item.dart';

class ColocMemberList extends StatelessWidget {
  final List<ColocMemberDetail> colocMembers;

  const ColocMemberList({super.key, required this.colocMembers});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (colocMembers.isEmpty) {
      return Center(
          child: Text('backoffice_colocMember_no_coloc_member_found'.tr()));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      itemCount: colocMembers.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final colocMember = colocMembers[index];
        return Center(
          child: ColocMemberListItem(
            colocMember: colocMember,
          ),
        );
      },
    );
  }
}
