import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  // ใช้สิ่งนี้เมื่อมี RiverPod
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() {
    return _PlaceListScreenState();
  }
}

class _PlaceListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placeFuture;

  @override
  void initState() {
    super.initState();
    _placeFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              ); // นำทางไปยังหน้า AddPlaceScreen
            },
            icon: const Icon(Icons.add),
          ),
        ], //สามารถเพิ่มปุ่มโดยการใช้ actions
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placeFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}
