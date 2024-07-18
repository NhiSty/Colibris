import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/home_screen.dart';
import 'package:front/website/pages/backoffice/colocations/components/search_bar_and_add_colocation_button.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

class TitleAndBreadcrumb extends StatelessWidget {
  const TitleAndBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(
          'backoffice_colocation_title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            html.window.location.reload();
            context.push(HomeScreen.routeName);
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
                  'backoffice_colocation_breadcrumb'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Center(
          child: SearchBarAndAddColocationButton(),
        ),
      ],
    );
  }
}
