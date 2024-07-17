import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:front/services/log_service.dart';
import 'package:front/website/pages/backoffice/logs/components/log_list_item.dart';

class LogList extends StatelessWidget {
  final List<Log> logs;

  const LogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(child: Text('backoffice_logs_no_log'.tr()));
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
      child: LogListItem(logs: logs),
    );
  }
}