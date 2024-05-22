import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataList = [
    {
      'title': 'Co-locations',
      'subtitle': '',
    },
    {
      'title': 'Co-location 1',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Vacances Venise',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends Marseille',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends Marseille',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends Marseille',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends Marseille',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends Marseille',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
    {
      'title': 'Week-ends fin',
      'subtitle':
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: IconButton(
                        icon: const Icon(
                          Icons.circle_notifications,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('clicked on notification button');
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
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    return GestureDetector(
                      onTap: () {
                        print('Clicked on ${item['title']}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.home),
                          title: Text(item['title'] as String),
                          subtitle: Text(item['subtitle'] as String),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
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
                print('clicked on add button');
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
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                print('clicked on home button');
              },
            ),
            IconButton(
              icon: Icon(Icons.thumbs_up_down),
              color: Colors.white,
              onPressed: () {
                print('clicked on like/dislike button');
              },
            ),
            IconButton(
              icon: Icon(Icons.chat),
              color: Colors.white,
              onPressed: () {
                print('clicked on chat button');
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
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
