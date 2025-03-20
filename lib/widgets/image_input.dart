import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
  });

  final Function(File image) onPickImage; // ใช้เพื่อส่งค่ากลับไปยัง widget หรือหน้าจอที่เรียกใช้ ImageInput.

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage; // สร้างตัวแปรที่เก็บไฟล์ภาพ

  void _takePicture() async {
    final imagePicker =
        ImagePicker(); // ใช้ libary Image_Picker และสร้าง Instant
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if (pickedImage == null) {
      return;
    } // เช็คว่าค่าว่าง

    setState(() {
      _selectedImage = File(pickedImage.path); // เก็บไฟล์ภาพที่เลือก
    });

    widget.onPickImage(_selectedImage!); // เพื่อส่งไฟล์ภาพกลับไปยัง widget อื่นที่เรียกใช้ ImageInput
  } // มีหน้าที่ส่งไฟล์ภาพที่เลือกกลับไปให้ widget ภายนอก

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    ); // ถ้า null ให้แสดงสิ่งนี้

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } // ถ้ามีภาพแสดงสิ่งนี้

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
