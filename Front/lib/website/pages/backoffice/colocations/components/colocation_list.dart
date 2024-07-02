import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/website/pages/backoffice/colocations/components/colocation_list_item.dart';

class ColocationList extends StatelessWidget {
  final List<Colocation> colocations;

  const ColocationList({super.key, required this.colocations});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (colocations.isEmpty) {
      return Center(child: Text('backoffice_colocation_no_colocation'.tr()));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      itemCount: colocations.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final colocation = colocations[index];
        return Center(
          child: ColocationListItem(
            colocation: colocation,
          ),
        );
      },
    );
  }
}
