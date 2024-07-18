import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/bloc/colocation_bloc.dart';
import 'package:front/colocation/colocation_tasklist_screen.dart';
import 'package:front/colocation/create_colocation.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'package:front/invitation/invitation_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:front/main.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    context.read<InvitationBloc>().add(FetchInvitations());
    context.read<ColocationBloc>().add(const FetchColocations());

    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'colocation_home'.tr(),
                            style: const TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          ),
                          BlocBuilder<InvitationBloc, InvitationState>(
                            builder: (context, state) {
                              if (state is InvitationLoading) {
                                return const CircularProgressIndicator();
                              } else if (state is InvitationError) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  onPressed: () {},
                                );
                              } else if (state is InvitationLoaded) {
                                final invitations = state.invitations;
                                if (invitations.isEmpty) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        showSnackBarFeedback(
                                          'colocation_no_invitation_yet'.tr(),
                                          Colors.blueAccent,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Stack(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        onPressed: () {
                                          context.push(
                                              InvitationListPage.routeName,
                                              extra: {
                                                'invitations': invitations,
                                              });
                                        },
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 7,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            invitations.length.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              } else {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      showSnackBarFeedback(
                                        'colocation_no_invitation_yet'.tr(),
                                        Colors.blueAccent,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'colocation_title'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<ColocationBloc, ColocationState>(
                      builder: (context, state) {
                        if (state is ColocationInitial ||
                            state is ColocationLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ColocationError) {
                          if (state.isDirty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'colocation_no_colocation'.tr(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ColocationLoaded) {
                          final colocations = state.colocations;
                          if (colocations.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 64,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'colocation_no_colocation'.tr(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return RefreshIndicator(
                              displacement: 50,
                              onRefresh: () async {
                                context
                                    .read<ColocationBloc>()
                                    .add(const FetchColocations());
                              },
                              child: ListView.builder(
                                itemCount: colocations.length,
                                itemBuilder: (context, index) {
                                  final item = colocations[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        ColocationTasklistScreen.routeName,
                                        extra: {
                                          'colocation': item,
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Card(
                                        color: Colors.blueGrey.withOpacity(0.05),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          leading: item.isPermanent
                                              ? Icon(
                                                  Icons.apartment,
                                                  color: Color(0xFF253BA6),
                                                )
                                              : Icon(
                                                  Icons.apartment,
                                                  color: Color(0xFFFF4F4F),
                                                ),
                                          title: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${'colocation_created_at'.tr()} ${DateTime.parse(item.createdAt).toLocal().toString().split(' ')[0]}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                item.location,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: Text('colocation_unknown_error'.tr()),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 70,
                right: 20,
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    context.push(CreateColocationPage.routeName);
                  },
                  backgroundColor: Colors.blueGrey[800],
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
