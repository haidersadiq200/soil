import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'sample_list_page.dart'; // تأكد من استيراد الصفحة

class SamplePage extends StatefulWidget {
  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController layerNumberController = TextEditingController();
  final TextEditingController blockNumberController = TextEditingController();
  final TextEditingController sectorNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image; // متغير لتخزين الصورة المحددة
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لاختيار صورة من المعرض
  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // دالة لحفظ العينة في Firestore
  Future<void> _saveSample() async {
    if (_image != null) {
      // هنا يمكنك إضافة الكود لرفع الصورة إلى Firebase Storage ثم حفظ URL
      // وإضافة العينة إلى Firestore
      await _firestore.collection('samples').add({
        'location': locationController.text,
        'layerNumber': layerNumberController.text,
        'blockNumber': blockNumberController.text,
        'sectorNumber': sectorNumberController.text,
        'collectionDateTime': DateTime.now(),
        // 'imageUrl': imageUrl,  // استبدل بـ URL الصورة المرفوعة
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حفظ العينة')));
      // إعادة تعيين الحقول بعد الحفظ
      locationController.clear();
      layerNumberController.clear();
      blockNumberController.clear();
      sectorNumberController.clear();
      setState(() {
        _image = null; // إعادة تعيين الصورة
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('يرجى اختيار صورة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة عينة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // حقل إدخال الموقع
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'الموقع'),
            ),
            // حقل إدخال رقم الطبقة
            TextField(
              controller: layerNumberController,
              decoration: InputDecoration(labelText: 'رقم الطبقة'),
            ),
            // حقل إدخال رقم البلزك
            TextField(
              controller: blockNumberController,
              decoration: InputDecoration(labelText: 'رقم البلزك'),
            ),
            // حقل إدخال رقم السكتر
            TextField(
              controller: sectorNumberController,
              decoration: InputDecoration(labelText: 'رقم السكتر'),
            ),
            SizedBox(height: 20),
            // زر لاختيار صورة
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('اختر صورة'),
            ),
            SizedBox(height: 20),
            // عرض الصورة المختارة إن وُجدت
            _image != null ? Image.file(_image!, height: 100) : SizedBox(),
            SizedBox(height: 20),
            // زر لحفظ العينة
            ElevatedButton(
              onPressed: _saveSample,
              child: Text('حفظ العينة'),
            ),
            SizedBox(height: 20), // إضافة مسافة بين الأزرار
            
            // زر لعرض العينات
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SampleListPage()),
                );
              },
              child: Text('عرض العينات'),
            ),
          ],
        ),
      ),
    );
  }
}
