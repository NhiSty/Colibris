import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:colibris/colocation/colocation_service.dart';
import 'package:colibris/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:colibris/main.dart';
import 'package:colibris/shared.widget/snack_bar_feedback_handling.dart';
import 'package:latlong2/latlong.dart';

class AddressResult {
  final String placeName;
  final LatLng location;

  AddressResult({required this.placeName, required this.location});
}

class CreateColocationPage extends StatefulWidget {
  const CreateColocationPage({super.key});
  static const routeName = "/create_colocation";

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
      final response = await Dio().get(url);

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
              showSnackBarFeedback('no_results_found'.tr(), Colors.blue));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            showSnackBarFeedback('error_during_search'.tr(), Colors.red));
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarFeedback('error_during_search'.tr(), Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('create_colocation_title'.tr()),
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'create_colocation_description'.tr(),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'create_colocation_search_address'.tr(),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            _searchAddress(_searchController.text);
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<AddressResult>(
                      items: searchResults.map((result) {
                        return DropdownMenuItem<AddressResult>(
                          value: result,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              result.placeName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
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
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[800]!),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red[500], fontSize: 15),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text(
                        'create_colocation_permanently'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
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
                            context.push(HomeScreen.routeName);
                            ScaffoldMessenger.of(context).showSnackBar(
                                showSnackBarFeedback(
                                    'create_colocation_created_successfully'
                                        .tr(),
                                    Colors.green));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                showSnackBarFeedback(
                                    'create_colocation_created_error'.tr(),
                                    Colors.red));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              showSnackBarFeedback(
                                  'create_colocation_message_select_address'
                                      .tr(),
                                  Colors.orange));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('create_colocation_submit'.tr(),
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
