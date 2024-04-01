import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:maps_demo/providers/paths_provider.dart';
import 'package:maps_demo/path_view.dart';

class PathsList extends ConsumerWidget {
  const PathsList({super.key});

  String formatTimestamp(DateTime timestamp) =>
      DateFormat('y MMM d H:m:s').format(timestamp);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paths = ref.watch(pathsProvider);
    return Column(
      children: [
        const Text(
          "Recorded paths",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: paths.length,
            itemBuilder: (context, index) => ListTile(
              onTap: paths[index].isNotEmpty
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PathView(paths[index]),
                          fullscreenDialog: true,
                        ),
                      );
                    }
                  : null,
              leading: const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: Colors.deepOrange,
              ),
              title: Text(
                paths[index].isNotEmpty
                    ? "${formatTimestamp(paths[index].first.timestamp)}\n -- ${formatTimestamp(paths[index].last.timestamp)}"
                    : "Empty record",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
