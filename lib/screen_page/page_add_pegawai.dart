import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latihan_crud_pegawai/model/model_pegawai.dart';

class AddPegawaiScreen extends StatefulWidget {
  @override
  _AddPegawaiScreenState createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void addPegawai() async {
    if (_formKey.currentState!.validate()) {
      final firstname = firstnameController.text;
      final lastname = lastnameController.text;
      final phonenumber = phonenumberController.text;
      final email = emailController.text;

      try {
        final response = await http.post(
          Uri.parse('http://192.168.40.142/pegawai/addPegawai.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstname': firstname,
            'lastname': lastname,
            'phonenumber': phonenumber,
            'email': email,
          }),
        );
        if (response.statusCode == 200) {
          Navigator.pop(context, true); // Signal success to previous screen
        } else {
          showErrorSnackBar('Failed to add pegawai');
        }
      } catch (e) {
        showErrorSnackBar('Failed to add pegawai: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pegawai',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Warna background app bar biru
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: firstnameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: lastnameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: phonenumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addPegawai,
                    child: Text('Tambah'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
