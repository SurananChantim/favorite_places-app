import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places; // สร้างตัวแปรเก็บโมเดลไว้เรียกใช้งาน

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    } //ถ้าหน้าจอไม่มีข้อมูลจะโชว์สิ่งนี้
    return ListView.builder(
      itemCount: places.length, // อย่าลืมใส่สิ่งนี้
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(places[index].image),
        ),
        title: Text(
          places[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ), // เป็นการเรียกใช้ตีมที่กำหนด
        ), // นำชื่อสถานที่มาแสดง
        subtitle: Text(
          places[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlaceDetailScreen(
                place: places[index],
              ),
            ),
          );
        }, // ทำให้ items ใน list สามารถกดได้
      ),
    );
  }
}
