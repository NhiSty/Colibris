import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';
import 'package:front/website/pages/backoffice/colocations/bloc/colocation_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class AddressResult {
  final String placeName;
  final LatLng location;

  AddressResult({required this.placeName, required this.location});
}

void showAddColocationDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  bool isPermanent = false;
  LatLng? selectedLocation;
  String? selectedAddress;
  List<AddressResult> searchResults = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<ColocationBloc>(context),
        child: BlocListener<ColocationBloc, ColocationState>(
          listener: (context, state) {
            if (state is ColocationLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('create_colocation_created_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is ColocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('create_colocation_created_error'.tr()),
                ),
              ));
            }
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('no_results_found'.tr()),
                        ),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('error_during_search'.tr()),
                      ),
                    ));
                  }
                } catch (e) {
                  print('Erreur: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('error_during_search'.tr()),
                    ),
                  ));
                }
              }

              return CustomDialog(
                title: 'create_colocation_title'.tr(),
                height: 400.0,
                width: 700.0,
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 56.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: DropdownButtonFormField<AddressResult>(
                            items: searchResults.map((result) {
                              return DropdownMenuItem<AddressResult>(
                                value: result,
                                child: Text(
                                  result.placeName,
                                  overflow: TextOverflow.ellipsis,
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
                              labelText:
                                  'create_colocation_select_address'.tr(),
                              border: const OutlineInputBorder(),
                            ),
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
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('cancel'.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedLocation != null) {
                        context.read<ColocationBloc>().add(AddColocation(
                              name: _nameController.text,
                              description: _descriptionController.text,
                              isPermanent: isPermanent,
                              latitude: selectedLocation!.latitude,
                              longitude: selectedLocation!.longitude,
                              location: selectedAddress!,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('fill_all_fields'.tr()),
                          ),
                        ));
                      }
                    },
                    child: Text('add'.tr()),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
