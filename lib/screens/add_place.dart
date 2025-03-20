import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  // ใช้สิ่งนี้เมื่อมี RiverPod
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController(); // ไว้ใช้คู่กับ controller
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text; // รับข้อความที่ถูกป้อนเข้ามา

    if (enteredTitle.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    } // ตรวจสอบว่าผู้ใช้งานป้อนข้อมูลครบหรือไม่ (enteredTitle ไม่ว่าง และ _selectedImage มีค่า)

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!); // สิ่งนี้จะทำให้สามารถ add new place และภาพ ได้

    Navigator.of(context).pop(); // เมื่อกดปุ่มจะย้อนกลับไป
  }

  @override
  void dispose() {
    _titleController.clear(); // ล้างข้อความใน controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'title'),
              controller: _titleController,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
              // callback ที่กำหนดให้ค่าที่ได้จาก widget.onPickImage (ไฟล์ภาพ) ถูกเก็บในตัวแปร _selectedImage
            ),
            const SizedBox(height: 10),
            LocationInput(onSelectLocation: (location) {
              _selectedLocation = location;
            },),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            )
          ],
        ),
      ),
    );
  }
}
