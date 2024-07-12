import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan_crud_pegawai/model/model_pegawai.dart';

class EditPegawaiScreen extends StatefulWidget {
  final Datum pegawai;

  EditPegawaiScreen({required this.pegawai});

  @override
  _EditPegawaiScreenState createState() => _EditPegawaiScreenState();
}

class _EditPegawaiScreenState extends State<EditPegawaiScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String selectedGender = 'Laki-laki';
  String selectedStatus = 'Pegawai Tetap';

  @override
  void initState() {
    super.initState();
    firstnameController.text = widget.pegawai.firstname;
    lastnameController.text = widget.pegawai.lastname;
    phonenumberController.text = widget.pegawai.phonenumber;
    emailController.text = widget.pegawai.email;
    selectedGender = widget.pegawai.jeniskelamin;
    selectedStatus = widget.pegawai.status;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> editPegawai() async {
    final firstname = firstnameController.text;
    final lastname = lastnameController.text;
    final phonenumber = phonenumberController.text;
    final email = emailController.text;

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        phonenumber.isEmpty ||
        email.isEmpty) {
      _showErrorSnackBar('All fields are required');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://192.168.226.142/pegawai/editPegawai.php?id=${widget.pegawai.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstname': firstname,
          'lastname': lastname,
          'phonenumber': phonenumber,
          'email': email,
          'jeniskelamin': selectedGender,
          'status': selectedStatus,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['is_success']) {
          // If edit successful, update the local widget data
          setState(() {
            widget.pegawai.firstname = firstname;
            widget.pegawai.lastname = lastname;
            widget.pegawai.phonenumber = phonenumber;
            widget.pegawai.email = email;
            widget.pegawai.jeniskelamin = selectedGender;
            widget.pegawai.status = selectedStatus;
          });
          Navigator.pop(context, true); // Indicate success
        } else {
          _showErrorSnackBar(jsonResponse['message'] ?? 'Failed to edit pegawai');
        }
      } else {
        _showErrorSnackBar('Failed to edit pegawai');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to edit pegawai: $e');
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    phonenumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pegawai'),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: firstnameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: lastnameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: phonenumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Laki-laki', 'Perempuan']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: ['Pegawai Tetap', 'Non Pegawai Tetap']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: editPegawai,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
