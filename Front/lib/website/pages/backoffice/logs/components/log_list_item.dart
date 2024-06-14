import 'package:flutter/material.dart';
import 'package:front/services/log_service.dart';

class LogListItem extends StatelessWidget {
  final Log log;

  const LogListItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.8;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    log.level == 'ERROR' ? Icons.error : Icons.info,
                    color: log.level == 'ERROR' ? Colors.red : Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Method: ${log.method}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Path: ${log.path}'),
                        Text('Client IP: ${log.clientIp}'),
                        Text('Date: ${log.date}'),
                        Text('Time: ${log.time}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${log.level} - ${log.status}',
                style: TextStyle(
                  color: log.level == 'ERROR' ? Colors.red : Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
