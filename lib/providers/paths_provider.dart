import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:maps_demo/models/location_record.dart';

part 'paths_provider.g.dart';

@Riverpod(keepAlive: true)
class Paths extends _$Paths {
  @override
  List<List<LocationRecord>> build() {
    final box = Hive.box('records');
    final paths = <List<LocationRecord>>[];
    for (final item in box.keys) {
      final data = box.get(item);
      paths.add(data.cast<LocationRecord>());
    }
    return paths;
  }
}
