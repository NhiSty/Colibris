import 'package:easy_localization/easy_localization.dart';
import 'package:feature_flags_toggly/feature_flags_toggly.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Feature(
      featureKeys: ['maintenance'],
      child: Scaffold(
        body: MaintenanceContent(),
      ),
    );
  }
}

class MaintenanceContent extends StatelessWidget {
  const MaintenanceContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        // Maintenance message
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.build,
                  color: Colors.orangeAccent,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'maintenance'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'maintenance_work'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
