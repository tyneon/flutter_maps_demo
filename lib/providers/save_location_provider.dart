import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:maps_demo/models/location_record.dart';

part 'save_location_provider.g.dart';

@Riverpod(keepAlive: true)
class SaveLocation extends _$SaveLocation {
  @override
  List<LocationRecord> build() => [];

  void add(LocationRecord location) {
    state = [...state, location];
  }

  void save() {
    if (state.isEmpty) {
      return;
    }
    final box = Hive.box('records');
    box.put(state.last.timestamp.toString(), state);
    state = [];
  }
}
