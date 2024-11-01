import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SampleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة العينات')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('samples').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final samples = snapshot.data!.docs;

          return ListView.builder(
            itemCount: samples.length,
            itemBuilder: (context, index) {
              final sample = samples[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('الموقع: ${sample['location']}'),
                subtitle: Text('تاريخ العينة: ${sample['collectionDateTime']}'),
              );
            },
          );
        },
      ),
    );
  }
}
