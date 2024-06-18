import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:latlong2/latlong.dart'; // Ensure this import is correct for your LatLng implementation

class AddressResult {
  final String placeName;
  final LatLng location;

  AddressResult({required this.placeName, required this.location});
}

class CreateColocationPage extends StatefulWidget {
  const CreateColocationPage({super.key});

  @override
  _CreateColocationPageState createState() => _CreateColocationPageState();
}

class _CreateColocationPageState extends State<CreateColocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  bool isPermanent = false;
  LatLng? selectedLocation;
  String? selectedAddress;
  List<AddressResult> searchResults = [];

  Future<void> _searchAddress(String query) async {
    try {
      final apiKey = dotenv.env['MAPBOX_KEY']!;
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$apiKey';
      final response =
          await Dio().get(url); // Use Dio directly for network request

      if (response.statusCode == 200) {
        final features = response.data['features'];

        if (features.isNotEmpty) {
          List<AddressResult> results =
              List<AddressResult>.from(features.map((feature) {
            final center = feature['center'];
            final placeName = feature['place_name'];
            return AddressResult(
              placeName: placeName,
              location: LatLng(center[1], center[0]),
            );
          }));

          setState(() {
            searchResults = results;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucun résultat trouvé')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la recherche')),
        );
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la recherche')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une colocation'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher une adresse',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchAddress(_searchController.text);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AddressResult>(
                  items: searchResults.map((result) {
                    return DropdownMenuItem<AddressResult>(
                      value: result,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.7, // Adjust this width as necessary
                        child: Text(
                          result.placeName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value?.location;
                      selectedAddress = value?.placeName;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sélectionner une adresse',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Colocation permanente'),
                  value: isPermanent,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (bool? value) {
                    setState(() {
                      isPermanent = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        selectedLocation != null) {
                      var res = await createColocation(
                        _nameController.text,
                        _descriptionController.text,
                        isPermanent,
                        selectedLocation!,
                        selectedAddress!,
                      );

                      if (res == 201) {
                        Navigator.pushNamed(context, '/home');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Colocation créée avec succès'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur lors de la création'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Veuillez sélectionner une adresse dans les résultats de recherche'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize:
                        const Size(double.infinity, 50), // Full-width button
                  ),
                  child: const Text('Créer la colocation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
