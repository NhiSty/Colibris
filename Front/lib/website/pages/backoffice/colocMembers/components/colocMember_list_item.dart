import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/services/colocMember_service.dart';
import 'package:front/website/pages/backoffice/colocMembers/dialogs/colocMembers/delete_coloc_member.dart';
import 'package:front/website/pages/backoffice/colocMembers/dialogs/colocMembers/edit_coloc_member.dart';
import 'package:front/website/pages/backoffice/colocMembers/dialogs/colocMembers/map_modal.dart';
import 'package:front/website/pages/backoffice/user_handle_page.dart';
import 'package:go_router/go_router.dart';

class ColocMemberListItem extends StatelessWidget {
  final ColocMemberDetail colocMember;

  ColocMemberListItem({super.key, required this.colocMember});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${'backoffice_colocMember_user_field'.tr()} ${colocMember.userFirstname} ${colocMember.userLastname}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.home, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${'backoffice_colocMember_colocation_field'.tr()} ${colocMember.colocationName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.manage_accounts_rounded,
                            color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${'backoffice_colocMember_owner_field'.tr()} ${colocMember.ownerFirstname} ${colocMember.ownerLastname}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${'backoffice_colocMember_joined_date_field'.tr()} ${colocMember.joinedAt}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${'backoffice_colocMember_score_field'.tr()} ${colocMember.score}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            colocMember.colocationAddress,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showEditColocMemberDialog(
                          context, colocMember.id, colocMember.score as double);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDeleteColocMemberDialog(context, colocMember.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.not_listed_location_rounded,
                        color: Colors.orange),
                    onPressed: () {
                      showMapModal(context, colocMember);
                    },
                  ),
                  IconButton(
                    icon: const Row(
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.green),
                        SizedBox(width: 8),
                        Icon(Icons.person, color: Colors.grey),
                      ],
                    ),
                    onPressed: () {
                      context.push(UserHandlePage.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
