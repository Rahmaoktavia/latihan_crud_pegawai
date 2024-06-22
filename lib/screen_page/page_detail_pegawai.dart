import 'package:flutter/material.dart';
import 'package:latihan_crud_pegawai/model/model_pegawai.dart';

class DetailPegawaiScreen extends StatelessWidget {
  final Datum pegawai;

  DetailPegawaiScreen({required this.pegawai});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pegawai'),
        backgroundColor: Colors.blue, // Ubah warna background AppBar menjadi biru
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 100, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              '${pegawai.firstname} ${pegawai.lastname}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Phone:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              '${pegawai.phonenumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              '${pegawai.email}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
