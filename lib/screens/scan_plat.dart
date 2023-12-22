import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> uploadImage(File imageFile) async {
    var apiUrl = Uri.parse('http://192.168.8.102:5000/process-image');

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
          setState(() {});
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String?> getResult() async {
    var apiUrl = Uri.parse('http://192.168.8.102:5000/process-image');

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

