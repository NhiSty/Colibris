import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TitleAndBreadcrumb extends StatelessWidget {
  const TitleAndBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, "/home");
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'home'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'backoffice_flipping_breadcrumb'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
