import 'package:app_parkir/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  GlobalKey qrKey = GlobalKey();
  late QRViewController qrController;
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Scanned Data: $result'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          await qrController.pauseCamera();
                          if (result.isNotEmpty) {
                            _navigateToNextPage(result);
                          }
                        },
                        child:
                            const Text('pause', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          await qrController.resumeCamera();
                        },
                        child: const Text('resume',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
        if (result.isNotEmpty) {
          _navigateToNextPage(result);
        }
      });
    });
  }

  void _navigateToNextPage(String data) {
    qrController.pauseCamera();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
            noPlat: "${result}",
            tanggalJam:
                "${DateFormat('dd-MM-yyyy').format(DateTime.now())} ${DateFormat('HH:mm:ss').format(DateTime.now())}"),
      ),
    );
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
