import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/colocations/dialogs/colocations/delete_colocation_dialog.dart';
import 'package:front/website/pages/backoffice/colocations/dialogs/colocations/edit_colocation_dialog.dart';
import 'package:go_router/go_router.dart';

class ColocationListItem extends StatelessWidget {
  final Colocation colocation;

  const ColocationListItem({super.key, required this.colocation});

  Future<Map<String, dynamic>> fetchOwnerData(int userId) async {
    UserService userService = UserService();
    return await userService.getUserById(userId);
  }

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
          child: Row(
            children: [
              Row(
                children: [
                  Icon(Icons.home, color: Colors.blue[800]),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        colocation.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchOwnerData(colocation.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                                'backoffice_colocation_error_loading_owner_info'
                                    .tr());
                          } else {
                            final owner = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'backoffice_colocation_owned_by'.tr()} ${owner['Firstname']} - ${owner['Lastname']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${owner['Email']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      colocation.description?.isNotEmpty == true
                          ? colocation.description!
                          : 'backoffice_colocation_no_description'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      colocation.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.message, color: Colors.green[800]),
                onPressed: () {
                  context.push('/backoffice/colocations/messages',
                      extra: {'id': colocation.id});
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[800]),
                onPressed: () {
                  showEditColocationDialog(context, colocation);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[800]),
                onPressed: () {
                  showDeleteColocationDialog(context, colocation);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
