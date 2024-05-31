import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/Colocation.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/colocation/create_colocation.dart';
import 'package:front/invitation/invitation_list_page.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<InvitationBloc>().add(FetchInvitations());

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
                        child: const Text(
                          'Accueil',
                          style: TextStyle(
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
                                    const SnackBar(
                                      content: Text(
                                          'Vous n\'avez pas de nouvelles invitations'),
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
              const Text(
                'Co-locations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Colocation>>(
                  future: fetchColocations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'Aucune colocation trouvée',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Text('Erreur: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              print('Clicked on ${item.name}');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: const Icon(Icons.home),
                                title: Text(item.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Créé le : ${DateTime.parse(item.createdAt).toLocal().toString().split(' ')[0]}'),
                                    Text('Description : ${item.description}'),
                                    Text('Ville : ${item.city}'),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        },
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
                    builder: (context) => CreateColocationPage(),
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
      bottomNavigationBar: Container(
        height: 60,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                print('clicked on home button');
              },
            ),
            IconButton(
              icon: const Icon(Icons.thumbs_up_down),
              color: Colors.white,
              onPressed: () {
                print('clicked on like/dislike button');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              color: Colors.white,
              onPressed: () {
                print('clicked on chat button');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                print('clicked on profile button');
              },
            ),
          ],
        ),
      ),
    );
  }
}
