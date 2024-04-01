import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:maps_demo/models/location_record.dart';
import 'package:maps_demo/providers/save_location_provider.dart';
import 'package:maps_demo/providers/paths_provider.dart';

class RecordLocationWidget extends ConsumerStatefulWidget {
  const RecordLocationWidget({super.key});

  @override
  ConsumerState<RecordLocationWidget> createState() =>
      _RecordLocationWidgetState();
}

class _RecordLocationWidgetState extends ConsumerState<RecordLocationWidget> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        if (await BackgroundLocation.isServiceRunning()) {
          // stop
          BackgroundLocation.stopLocationService();
          ref.read(saveLocationProvider.notifier).save();
          ref.read(pathsProvider.notifier).refresh();
          setState(() {
            isRecording = false;
          });
        } else {
          // start
          await BackgroundLocation.setAndroidNotification(
            title: 'Background service is running',
            message: 'Background location in progress',
            icon: '@mipmap/ic_launcher',
          );
          //await BackgroundLocation.setAndroidConfiguration(1000);
          await BackgroundLocation.startLocationService(distanceFilter: 20);
          BackgroundLocation.getLocationUpdates(
            (location) => ref.read(saveLocationProvider.notifier).add(
                  LocationRecord.fromLocation(
                    location: location,
                    timestamp: DateTime.now(),
                  ),
                ),
          );
          setState(() {
            isRecording = true;
          });
        }
      },
      icon: Icon(
        isRecording ? Icons.location_disabled : Icons.location_searching,
      ),
      label: Text("${isRecording ? "Stop" : "Start"} recording location"),
    );
  }
}
