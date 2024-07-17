import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:front/services/log_service.dart';

class LogListItem extends StatelessWidget {
  final List<Log> logs;

  const LogListItem({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(child: Text('backoffice_logs_no_log'.tr()));
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(label: Text('backoffice_logs_method'.tr())),
                  DataColumn(label: Text('backoffice_logs_path'.tr())),
                  DataColumn(label: Text('backoffice_logs_client_ip'.tr())),
                  DataColumn(label: Text('backoffice_logs_user_date'.tr())),
                  DataColumn(label: Text('backoffice_logs_user_time'.tr())),
                  DataColumn(label: Text('backoffice_logs_status'.tr())),
                ],
                rows: logs.map((log) {
                  Color? rowColor =
                      log.level == "ERROR" ? Colors.red.withOpacity(0.2) : null;

                  return DataRow(
                    color: WidgetStateProperty.all(rowColor),
                    cells: [
                      DataCell(Text(log.method)),
                      DataCell(Text(log.path)),
                      DataCell(Text(log.clientIp)),
                      DataCell(Text(log.date)),
                      DataCell(Text(log.time)),
                      DataCell(Text(log.status.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
