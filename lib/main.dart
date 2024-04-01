import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:maps_demo/providers/save_location_provider.dart';
import 'package:maps_demo/models/location_record.dart';
import 'package:maps_demo/record_location_widget.dart';
import 'package:maps_demo/paths_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationRecordAdapter());
  await Hive.openBox('records');

  await Permission.location.request();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    ref.watch(saveLocationProvider);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: RecordLocationWidget(),
                ),
                Expanded(
                  child: PathsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
