import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'package:intl/intl.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

 

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;
  String qrData = '';


    
  


  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> uploadImage(File imageFile) async {
    var apiUrl = Uri.parse('http://192.168.1.87:5000/process-image');

    try {
      var request = http.MultipartRequest('POST', apiUrl);
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        String? result = await getResult();
        if (result != null) {
          processResult(result);
         
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String?> getResult() async {
    var apiUrl = Uri.parse('http://192.168.1.87:5000/process-image');

    try {
      var response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to get result. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting result: $e');
      return null;
    }
  }

  void processResult(String result) {

  

    // Proses hasil plat
    // ... implementasi pengolahan hasil plat di sini
    print('Hasil Plates: $result');
     try {
      // Parse JSON respons
      Map<String, dynamic> jsonResponse = json.decode(result);

      // Ekstrak nilai "text"
      var textValue = jsonResponse['Hasil Plates'][0]['text'];

      

      // Tampilkan nilai ke terminal
      print('Nilai Text: $textValue');

      // Periksa apakah nilai tidak null atau kosong sebelum melakukan navigasi
      if (textValue.isNotEmpty) {

        

        // Navigasi ke halaman berikutnya dengan nilai teks yang diekstrak
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
            noPlat: "${textValue}",
            tanggalJamMasuk:
                "${DateFormat('dd-MM-yyyy').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
          ),
        );
      }
    } catch (e) {
      print('Error parsing JSON: $e');
    }
    // Pastikan bahwa result sesuai dengan struktur yang diharapkan
    // Misalnya, Anda bisa menambahkan validasi JSON di sini
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: CameraPreview(controller),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                pictureFile = await controller.takePicture();
                setState(() {});

                if (pictureFile != null) {
                  await uploadImage(File(pictureFile!.path));
                }
              },
              child: const Text('Capture Image'),
            ),
          ),
        ],
      ),
    );
  }
}

