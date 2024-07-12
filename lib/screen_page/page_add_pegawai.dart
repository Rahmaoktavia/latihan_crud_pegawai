import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPegawaiScreen extends StatefulWidget {
  @override
  _AddPegawaiScreenState createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String selectedGender = 'Laki-laki';
  String selectedStatus = 'Pegawai Tetap';

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
          Uri.parse('http://192.168.226.142/pegawai/addPegawai.php'),
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

          if (jsonResponse.containsKey('is_success') && jsonResponse['is_success'] is bool) {
            if (jsonResponse['is_success']) {
              Navigator.pop(context, true); // Signal success to previous screen
            } else {
              showErrorSnackBar(jsonResponse['message'] ?? 'Failed to add pegawai');
            }
          } else {
            showErrorSnackBar('Failed to add pegawai: Invalid server response');
          }
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
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
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        border: OutlineInputBorder(),
                      ),
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
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
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
        ],
      ),
    );
  }
}
