import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/featureFlag/featureFlag.dart';
import 'package:front/featureFlag/feature_flag_service.dart';
import 'package:front/website/pages/backoffice/flipping/breadcrumb.dart';

class FeatureTogglePage extends StatefulWidget {
  const FeatureTogglePage({super.key});

  @override
  _FeatureTogglePageState createState() => _FeatureTogglePageState();
}

class _FeatureTogglePageState extends State<FeatureTogglePage> {
  List<FeatureFlag> _featureFlags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeatureFlags();
  }

  Future<void> _loadFeatureFlags() async {
    try {
      List<FeatureFlag> flags = await fetchFeatureFlags();
      setState(() {
        _featureFlags = flags;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${'backoffice_flipping_fail_load_data'.tr()} $e'),
        ),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFeatureFlag(FeatureFlag flag) async {
    try {
      flag.value = !flag.value;
      await updateFeatureFlag(flag);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${'backoffice_flipping_fail_update_data'.tr()} $e'),
        ),
      ));
      setState(() {
        flag.value = !flag.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'backoffice_flipping_title'.tr(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'backoffice_flipping_description'.tr(),
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const TitleAndBreadcrumb(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _featureFlags.length,
                        itemBuilder: (context, index) {
                          final flag = _featureFlags[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  flag.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Switch(
                                  value: flag.value,
                                  onChanged: (value) {
                                    _toggleFeatureFlag(flag);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
