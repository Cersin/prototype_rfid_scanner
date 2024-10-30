import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.callback});

  final VoidCallback callback;

  Future<void> _saveImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // final Directory duplicateFilePath =
    //     await getApplicationDocumentsDirectory();

    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder = Directory('${directory.path}/');
    if (!await appDocDirFolder.exists()) {
      await appDocDirFolder.create(recursive: true);
    }

    File(image.path).copy('${directory.path}/${image.name}');

    callback();
  }

  Future<void> _saveAd() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // final Directory duplicateFilePath =
    //     await getApplicationDocumentsDirectory();

    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder = Directory('${directory.path}/ads/');
    if (!await appDocDirFolder.exists()) {
      await appDocDirFolder.create(recursive: true);
    }
    // File(image.path).copy('${directory.path}/ads/${image.name}');
    await File(image.path).copy('${directory.path}/ads/${image.name}');

    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Telegrosik'),
          ),
          ListTile(
            title: const Text('Wrzuć plik'),
            onTap: _saveImage,
          ),
          ListTile(
            title: const Text('Wrzuć plik reklamowy'),
            onTap: _saveAd,
          ),
        ],
      ),
    );
  }
}
