import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telegrosik/widgets/ads_carousel.dart';
import 'package:telegrosik/widgets/main_drawer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Key key = UniqueKey();
  File? loadedFile;
  String? loadedValue;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _onBarcodeScan(String value) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    bool exists = await File('${directory.path}/$value.png').exists();
    if (exists) {
      setState(() {
        loadedFile = File('${directory.path}/$value.png');
        loadedValue = value;
      });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          loadedFile = null;
          loadedValue = null;
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: "Nie wykryto zdjęcia",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _onSetImage() {
    key = UniqueKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black,
          drawer: MainDrawer(
            callback: _onSetImage,
          ),
          body: loadedFile != null
              ? Stack(children: [
                  Image.file(
                    loadedFile!,
                    fit: BoxFit.contain,
                    height: height,
                  ),
                  kDebugMode
                      ? Positioned(
                          bottom: 20,
                          child: Center(
                            child: Text(
                              loadedValue ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ),
                        )
                      : const Center(),
                ])
              : BarcodeKeyboardListener(
                  onBarcodeScanned: _onBarcodeScan,
                  child: AdsCarousel(
                    key: key,
                  ),
                )),
    );
  }
}
