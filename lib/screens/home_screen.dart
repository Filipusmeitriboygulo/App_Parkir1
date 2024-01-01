import 'package:app_parkir/screens/print.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'scanner_qr.dart';
import 'scan_plat.dart';
import 'package:camera/camera.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class DataParkir extends StatefulWidget {
  const DataParkir({
    super.key,
    required this.noPlat,
    required this.tanggalJamMasuk,
    required this.tanggalJamKeluar,
  });

  final String noPlat;
  final String tanggalJamMasuk;
  final String tanggalJamKeluar;

  @override
  State<DataParkir> createState() => _DataParkirState();
}


class HomeScreen extends StatelessWidget {
  final String noPlat;
  final String tanggalJamMasuk;
  final String tanggalJamKeluar;

  HomeScreen(
      {this.noPlat = '',
      this.tanggalJamMasuk = '',
      this.tanggalJamKeluar = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Image.asset(
            "assets/images/parkdin.png",
            color: Colors.white,
          ),
          title: Text(
            "Park-Din",
            style: TextStyle(color: Colors.white),
          ),
          actions: [PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: Text('Data Parkir'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PrintPage()));
            }
              ),
                      PopupMenuItem(
                        child: Text('koneksi printer'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrintPage()));
                        },
                      ),
                       PopupMenuItem(child: Text('Data Parkir'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PrintPage()));
            }
              ),
                      PopupMenuItem(
                        child: Text('LogOut'),
                        onTap: () {},
                      ),

          ]
          )
          
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.qr_code),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Pilih'),
              content: Container(
                height: 100,
                child: Column(
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
                : DataParkir(
                    noPlat: noPlat,
                    tanggalJamMasuk: tanggalJamMasuk,
                    tanggalJamKeluar: tanggalJamKeluar)));
  }
}



class _DataParkirState extends State<DataParkir> {

  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  String jenisKendaraan = "";

  void printData(
      String idPetugas, String noPlat, String jk, String masuk) async {
    if ((await printer.isConnected)!) {
      printer.printCustom('jenis kendaraan: $jk', 1, 1);
      printer.printCustom('id petugas: $idPetugas', 1, 1);
      printer.printCustom('tanggal/jam masuk: $masuk', 1, 1);
      printer.printQRcode(noPlat, 200, 200, 1);
      printer.printNewLine();
     
    }
  }
 

    
User user = FirebaseAuth.instance.currentUser!;

  final databaseReference = FirebaseDatabase.instance
      .ref("parkiran/juru_parkir"); //untuk insert lewat firebase
  

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
          leading: Icon(Icons.grid_on),
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
                                  groupValue: jenisKendaraan,
                                  onChanged: (value) {
                                    setState(() {
                                      jenisKendaraan = value!;
                                      Navigator.pop(context);
                                    });
                                  }),
                              title: Text("Mobil"),
                            ),
                            ListTile(
                              leading: Radio(
                                  value: "Motor",
                                  groupValue: jenisKendaraan,
                                  onChanged: (value) {
                                    setState(() {
                                      jenisKendaraan = value!;
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
              child: jenisKendaraan != ""
                  ? Text("${jenisKendaraan}")
                  : Text("Pilih")),
        ),
        ListTile(
          leading: Icon(Icons.date_range_outlined),
          title: Text("Masuk:"),
          trailing: Text("${widget.tanggalJamMasuk}"),
        ),
        (widget.tanggalJamKeluar != "")
            ? Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.date_range_rounded),
                    title: Text("Keluar:"),
                    trailing: Text("${widget.tanggalJamKeluar}"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    "Durasi: 2 Jam",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    "Total: Rp1000",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        //untuk update data kendaraan keluar belum siap
                        await databaseReference
                            .child(DateTime.now().microsecond.toString())
                            .set({
                          'id_juruparkir': user.uid,
                          'no_plat': widget.noPlat,
                          'jenis_kendaraan': jenisKendaraan,
                          'tanggal_masuk': widget.tanggalJamMasuk
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>  PrintPage()));
                               
                      },
                      child: Text("Simpan")),
                ],
              )
            : ElevatedButton(
                onPressed: ()async
                //untuk input kendaraan masuk on progres
                {
                   await databaseReference.child(user.uid).child('kendaraan').child(DateTime.now().microsecond.toString())
                            .set({
                          'id_kendaraan': 'kendaraan${DateTime.now().microsecond.toString()}',
                          'no_plat': widget.noPlat,
                          'jenis_kendaraan': jenisKendaraan,
                          'tanggal_masuk': widget.tanggalJamMasuk
                        });
                    printData(
                      'kendaraan${DateTime.now().microsecond.toString()}', '${widget.noPlat}', '${jenisKendaraan}', '${widget.tanggalJamMasuk}');
                      Navigator.pop(context);
                    
                          
                },
                child: Text("Cetak"))
      ],
    );
  }
}
