import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latihan_crud_pegawai/model/model_pegawai.dart';
import 'package:latihan_crud_pegawai/screen_page/page_add_pegawai.dart';
import 'package:latihan_crud_pegawai/screen_page/page_detail_pegawai.dart';
import 'package:latihan_crud_pegawai/screen_page/page_edit_pegawai.dart';

class PegawaiScreen extends StatefulWidget {
  @override
  _PegawaiScreenState createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  List<Datum> pegawai = [];

  @override
  void initState() {
    super.initState();
    fetchPegawai();
  }

  Future<void> fetchPegawai() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.226.142/pegawai/getPegawai.php'));
      if (response.statusCode == 200) {
        final List<Datum> parsedPegawai =
            modelPegawaiFromJson(response.body).data;
        setState(() {
          pegawai = parsedPegawai;
        });
      } else {
        _showErrorSnackBar('Failed to load pegawai');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load pegawai: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateToAddPegawaiScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPegawaiScreen()),
    );

    if (result != null && result) {
      fetchPegawai(); // Refresh list if new pegawai added successfully
    }
  }

  void navigateToEditPegawaiScreen(Datum pegawai) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPegawaiScreen(pegawai: pegawai)),
    );

    if (result != null && result) {
      fetchPegawai(); // Refresh list if pegawai edited successfully
    }
  }

  void deletePegawaiDialog(Datum pegawai) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Pegawai'),
          content: Text('Are you sure you want to delete this pegawai?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.delete(
                    Uri.parse('http://192.168.226.142/pegawai/deletePegawai.php?id=${pegawai.id}'),
                  );

                  if (response.statusCode == 200) {
                    var responseData = json.decode(response.body);
                    if (responseData['is_success']) {
                      fetchPegawai(); // Refresh pegawai list after deleting
                      Navigator.pop(context);
                    } else {
                      _showErrorSnackBar(responseData['message']);
                    }
                  } else {
                    _showErrorSnackBar('Failed to delete pegawai');
                  }
                } catch (e) {
                  _showErrorSnackBar('Failed to delete pegawai: $e');
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showDetailScreen(Datum pegawai) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPegawaiScreen(pegawai: pegawai),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Pegawai',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Warna background app bar
      ),
      body: ListView.builder(
        itemCount: pegawai.length,
        itemBuilder: (context, index) {
          final pegawaiItem = pegawai[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading:
              Icon(Icons.person, size: 40, color: Colors.blue), // Icon pegawai
              title: Text('${pegawaiItem.firstname} ${pegawaiItem.lastname}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Phone: ${pegawaiItem.phonenumber}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Email: ${pegawaiItem.email}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => navigateToEditPegawaiScreen(pegawaiItem),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletePegawaiDialog(pegawaiItem),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.green),
                    onPressed: () => showDetailScreen(pegawaiItem),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddPegawaiScreen, // Navigate to AddPegawaiScreen on press
      ),
    );
  }
}
