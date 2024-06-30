import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
            SnackBar(content: Text('no_results_found'.tr())),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_during_search'.tr())),
        );
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_during_search'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_colocation_title'.tr()),
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
                      return 'please_give_name'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'create_colocation_name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'create_colocation_description'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'create_colocation_search_address'.tr(),
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
                  decoration: InputDecoration(
                    labelText: 'create_colocation_select_address'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('create_colocation_permanently'.tr()),
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
                          SnackBar(
                            content: Text(
                                'create_colocation_created_successfully'.tr()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('create_colocation_created_error'.tr()),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'create_colocation_message_select_address'.tr()),
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
                  child: Text('create_colocation_submit'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
