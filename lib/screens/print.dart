import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

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
                },
                child: Text('connect')),
            ElevatedButton(
                onPressed: () {
                  printer.disconnect();
                },
                child: Text('disconnect')),
            ElevatedButton(
                onPressed: () async {
                  if ((await printer.isConnected)!) {
                    printer.printNewLine();
                    printer.printQRcode("BL 0987 FE", 100, 100, 1);
                    printer.printCustom("mesge", 0, 1);
                  }
                },
                child: Text('print'))
          ],
        ),
      ),
    );
  }
}
