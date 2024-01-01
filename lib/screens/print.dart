import 'package:app_parkir/screens/home_screen.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PrintPage extends StatefulWidget {

  // final String idpetugas;
  // final String noPlat;
  // final String jk;
  // final String masuk;

  // PrintPage({required this.idpetugas,required this.noPlat,required this.jk, required this.masuk});
  

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  // void printData(String idPetugas,String noPlat, String jk, String masuk) async {
  //    if ((await printer.isConnected)!) {
  //                   printer.printNewLine();
  //                   printer.printQRcode(noPlat, 100, 100, 1);
  //                   printer.printCustom('jenis kendaraan: $jk', 0, 1);
  //                   printer.printCustom('id petugas: $idPetugas', 0, 1);
  //                   printer.printCustom('tanggal/jam masuk: $masuk', 0, 1);
  //                 }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('print barcode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
                hint: Text('Select Thermal Printer'),
                onChanged: (device) {
                  setState(() {
                    selectedDevice = device;
                  });
                },
                value: selectedDevice,
                items: devices
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name!),
                          value: e,
                        ))
                    .toList()),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  printer.connect(selectedDevice!);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));

                },
                child: Text('connect')),
            ElevatedButton(
                onPressed: () {
                  printer.disconnect();
                 Navigator.pop(context);
                },
                child: Text('disconnect')),
           
          ],
        ),
      ),
    );
  }
}
