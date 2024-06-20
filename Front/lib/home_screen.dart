import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/bloc/colocation_bloc.dart';
import 'package:front/colocation/create_colocation.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'package:front/invitation/invitation_list_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<InvitationBloc>().add(FetchInvitations());
    context.read<ColocationBloc>().add(const FetchColocations());

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          'colocation_home'.tr(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: BlocBuilder<InvitationBloc, InvitationState>(
                        builder: (context, state) {
                          if (state is InvitationLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is InvitationError) {
                            return IconButton(
                              icon: const Icon(
                                Icons.circle_notifications,
                                color: Colors.white,
                                size: 38,
                              ),
                              onPressed: () {},
                            );
                          } else if (state is InvitationLoaded) {
                            final invitations = state.invitations;
                            if (invitations.isEmpty) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.circle_notifications,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'colocation_no_invitation_yet'.tr()),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.circle_notifications,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InvitationListPage(
                                            invitations: invitations,
                                          ),
                                        ),
                                      );
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
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'colocation_title'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: BlocBuilder<ColocationBloc, ColocationState>(
                  builder: (context, state) {
                    if (state is ColocationInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ColocationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ColocationError) {
                      if (state.isDirty) {
                        return Center(
                          child: Text(
                            'colocation_no_colocation'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ColocationLoaded) {
                      final colocations = state.colocations;
                      if (colocations.isEmpty) {
                        return Center(
                          child: Text(
                            'colocation_no_colocation'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: colocations.length,
                          itemBuilder: (context, index) {
                            final item = colocations[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/colocation/task-list',
                                    arguments: {
                                      'colocation': item,
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: const Icon(Icons.home),
                                  title: Text(item.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${'colocation_created_at'.tr()}${DateTime.parse(item.createdAt).toLocal().toString().split(' ')[0]}'),
                                      Text(
                                          '${'colocation_description'.tr()}${item.description}'),
                                      Text(item.location),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            );
                          },
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
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateColocationPage(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Text(
                '+',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
