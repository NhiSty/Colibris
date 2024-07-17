import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_parameters.dart';
import 'package:front/main.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:go_router/go_router.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';

class ColocationUpdatePage extends StatefulWidget {
  final int colocationId;
  const ColocationUpdatePage({super.key, required this.colocationId});
  static const routeName = "/colocation-update";

  @override
  _ColocationUpdateWidgetState createState() => _ColocationUpdateWidgetState();
}

class _ColocationUpdateWidgetState extends State<ColocationUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  late Map<String, dynamic> _colocationData;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isPermanent = false;

  @override
  void initState() {
    super.initState();
    fetchColocation(widget.colocationId).then((colocation) {
      setState(() {
        _colocationData = colocation;
        _isLoading = false;
        _nameController.text = _colocationData['Name'];
        _descriptionController.text = _colocationData['Description'];
        isPermanent = _colocationData['IsPermanent'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.edit_location_alt, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                'update_colocation_title'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'update_colocation_name'.tr(),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorStyle: TextStyle(color: Colors.red[500], fontSize: 15),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'update_colocation_description'.tr(),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text('update_colocation_permanently'.tr(),
                        style: const TextStyle(color: Colors.white)),
                    value: isPermanent,
                    checkColor: Colors.white,
                    activeColor: Colors.blueGrey[800],
                    onChanged: (bool? value) {
                      setState(() {
                        isPermanent = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var res = await updateColocation(
                          widget.colocationId,
                          _nameController.text,
                          _descriptionController.text,
                          isPermanent,
                        );

                        if (res == 200) {
                          context.push(ColocationSettingsPage.routeName,
                                extra: {'colocationId': widget.colocationId
                              });
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'update_colocation_updated_successfully'.tr(),
                              Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'update_colocation_updated_error'.tr(),
                              Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey[800],
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    ),
                    child: Text('update_colocation_update_submit'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
