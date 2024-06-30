import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/services/log_service.dart';
import 'package:front/website/pages/backoffice/logs/components/log_list_item.dart';

class LogList extends StatelessWidget {
  final List<Log> logs;

  const LogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (logs.isEmpty) {
      return Center(child: Text('backoffice_logs_no_log'.tr()));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      itemCount: logs.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final log = logs[index];
        return Center(
          child: LogListItem(
            log: log,
          ),
        );
      },
    );
  }
}
