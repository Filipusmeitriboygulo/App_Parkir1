import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
void main(List<String> args) {
  runApp(QrGenerate());
}


class QrGenerate extends StatelessWidget {

  String kode = "BK 0900 LP";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: PrettyQrView.data(data: kode)),
      ),
    );
  }
}