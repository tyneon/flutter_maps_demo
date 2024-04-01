import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:maps_demo/models/location_record.dart';

const Map<String, String> _tileDataSources = {
  'Open Street Map': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  'Google Maps': 'http://mt0.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
};

class PathView extends StatefulWidget {
  final List<LocationRecord> path;
  const PathView(this.path, {super.key});

  @override
  State<PathView> createState() => _PathViewState();
}

class _PathViewState extends State<PathView> {
  bool showIntermediatePoints = false;
  String tileDataSourceIndex = _tileDataSources.keys.toList().first;

  Marker buildMarker(String text, LatLng point) => Marker(
        point: point,
        width: 100,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.deepOrange,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 7,
                right: 7,
                bottom: 2,
                top: 1,
              ),
              child: Text(text),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final startPoint =
        LatLng(widget.path.first.latitude, widget.path.first.longitude);
    final finishPoint =
        LatLng(widget.path.last.latitude, widget.path.last.longitude);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showIntermediatePoints = !showIntermediatePoints;
              });
            },
            icon: Icon(showIntermediatePoints
                ? Icons.location_off
                : Icons.location_on),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ListView(
                  children: widget.path
                      .map(
                        (item) => ListTile(
                          title: Text(
                            "${item.latitude}, ${item.longitude}",
                          ),
                          subtitle: Text(
                              "speed: ${(item.speed * 18 / 5).toStringAsFixed(1)} km/h, alt: ${item.altitude.toStringAsFixed(0)}"),
                        ),
                      )
                      .toList(),
                ),
              );
            },
            icon: const Icon(Icons.data_object),
          ),
          PopupMenuButton<String>(
            initialValue: tileDataSourceIndex,
            onSelected: (value) {
              setState(() {
                tileDataSourceIndex = value;
              });
            },
            icon: const Icon(Icons.map),
            itemBuilder: (context) => _tileDataSources.entries
                .map(
                  (entry) => PopupMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.key),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: startPoint,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: _tileDataSources[tileDataSourceIndex],
            userAgentPackageName: 'com.example.maps_demo',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.path
                    .map(
                      (location) => LatLng(
                        location.latitude,
                        location.longitude,
                      ),
                    )
                    .toList(),
                strokeWidth: 5,
                color: Colors.deepOrange,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              buildMarker("Start", startPoint),
              buildMarker("Finish", finishPoint),
              if (showIntermediatePoints)
                ...widget.path
                    .map((item) => Marker(
                          point: LatLng(item.latitude, item.longitude),
                          height: 70,
                          child: const Align(
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 40,
                            ),
                          ),
                        ))
                    .toList(),
            ],
          ),
          SimpleAttributionWidget(
            source: Text('OpenStreetMap contributors'),
          ),
        ],
      ),
      // ListView(
      //   children: path
      //       .map(
      //         (item) => ListTile(
      //           title: Text(
      //             "${item.latitude}, ${item.longitude}",
      //           ),
      //         ),
      //       )
      //       .toList(),
      // ),
    );
  }
}
