import 'package:flutter/material.dart';
import 'scanner_qr.dart';
import 'scan_plat.dart';
import 'package:camera/camera.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:flutter_experiment/camera_page.dart';

class HomeScreen extends StatelessWidget {
  final String noPlat;
  final String tanggalJam;

  HomeScreen({this.noPlat = '', this.tanggalJam = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Aplikasi Parkir"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.qr_code),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Pilih'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        await availableCameras().then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraPage(
                                cameras: value,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text("Scan Plat Kendaraan")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRScanPage()));
                      },
                      child: Text("Scan QR")),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: noPlat.isEmpty
                ? Center(
                    child: Text("scan QR parkir"),
                  )
                : DataParkir(noPlat: noPlat, tanggalJam: tanggalJam)));
  }
}

class DataParkir extends StatefulWidget {
  const DataParkir({
    super.key,
    required this.noPlat,
    required this.tanggalJam,
  });

  final String noPlat;
  final String tanggalJam;

  @override
  State<DataParkir> createState() => _DataParkirState();
}

class _DataParkirState extends State<DataParkir> {
  String _jenisKendaraan = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
            child: Text(
          "Data Parkir",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
        SizedBox(
          height: 15,
        ),
        Container(
            alignment: Alignment.center,
            height: 200,
            width: 200,
            child: PrettyQrView.data(data: widget.noPlat)),
        SizedBox(
          height: 15,
        ),
        ListTile(
          leading: Icon(Icons.data_object),
          title: Text("Nomor Plat:"),
          trailing: Text("${widget.noPlat}"),
        ),
        ListTile(
          leading: Icon(Icons.motorcycle),
          title: Text("Jenis Kendaraan"),
          trailing: TextButton(
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Pilih kendaraan'),
                      content: Container(
                        height: 200,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Radio(
                                  value: "mobil",
                                  groupValue: _jenisKendaraan,
                                  onChanged: (value) {
                                    setState(() {
                                      _jenisKendaraan = value!;
                                      Navigator.pop(context);
                                    });
                                  }),
                              title: Text("Mobil"),
                            ),
                            ListTile(
                              leading: Radio(
                                  value: "Motor",
                                  groupValue: _jenisKendaraan,
                                  onChanged: (value) {
                                    setState(() {
                                      _jenisKendaraan = value!;
                                      Navigator.pop(context);
                                    });
                                  }),
                              title: Text("Motor"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              child: _jenisKendaraan != ""
                  ? Text("${_jenisKendaraan}")
                  : Text("Pilih")),
        ),
        ListTile(
          leading: Icon(Icons.date_range_outlined),
          title: Text("Masuk:"),
          trailing: Text("${widget.tanggalJam}}"),
        ),
        ListTile(
          leading: Icon(Icons.date_range_rounded),
          title: Text("Keluar:"),
          trailing: Text("20/09/2023 12:12:00"),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () {}, child: Text("Print"))
      ],
    );
  }
}
