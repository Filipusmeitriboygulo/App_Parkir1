import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScanPage(),
    );
  }
}

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  GlobalKey qrKey = GlobalKey();
  late QRViewController qrController;
  String qrData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('QR Data: $qrData'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData.code!;
        if (qrData.isNotEmpty) {
          _navigateToNextPage(qrData);
        }
      });
    });
  }

  void _navigateToNextPage(String data) {
    qrController?.pauseCamera();
    // Pindah ke halaman baru dengan data QR yang terbaca
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(data: data),
      ),
    );
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}

class NextPage extends StatelessWidget {
  final String data;

  const NextPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('Data dari QR: $data'),
      ),
    );
  }
}
