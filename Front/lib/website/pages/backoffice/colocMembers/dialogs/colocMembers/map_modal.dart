import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front/services/colocMember_service.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

void showMapModal(BuildContext context, ColocMemberDetail colocMember) {
  var apiKey = dotenv.env['MAPBOX_KEY']!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Location of ${colocMember.colocationName}',
        width: 600.0,
        height: 400.0,
        content: FlutterMap(
          options: MapOptions(
            center: LatLng(
              colocMember.latitude,
              colocMember.longitude,
            ),
            zoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$apiKey",
              additionalOptions: const {
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    colocMember.latitude,
                    colocMember.longitude,
                  ),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Container(
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text('close'.tr()),
          ),
        ],
      );
    },
  );
}
