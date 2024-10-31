import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<List<FileSystemEntity>> _getAds() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> list =
        Directory('${directory.path}/ads').listSync();
    return list;
  }

  Future<List<FileSystemEntity>> _getFiles() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> list = Directory(directory.path).listSync();
    return list;
  }

  Future<void> _deleteFile(
      {FileSystemEntity? fileEntity, bool ads = true}) async {
    if (fileEntity == null) return;
    try {
      await fileEntity.delete();
      if (ads) {
        setState(() {
          _getAds();
        });
      } else {
        setState(() {
          _getFiles();
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Wystąpił błąd',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _saveAd() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder = Directory('${directory.path}/ads/');
    if (!await appDocDirFolder.exists()) {
      await appDocDirFolder.create(recursive: true);
    }
    // File(image.path).copy('${directory.path}/ads/${image.name}');
    await File(image.path).copy('${directory.path}/ads/${image.name}');

    setState(() {
      _getAds();
    });
  }

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

    setState(() {
      _getFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.file_copy),
              text: 'Pliki osadzonych',
            ),
            Tab(
              icon: Icon(Icons.pause_presentation),
              text: 'Pliki reklamowe',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
                future: _getFiles(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FileSystemEntity>?> snapshot) {
                  if (snapshot.data == null) {
                    return OutlinedButton(
                        onPressed: _saveImage,
                        child: const Text('Dodaj nowy plik osadzonego'));
                  }

                  final snapshotImages = snapshot.data!
                      .where((item) =>
                          item.path.endsWith('.png') ||
                          item.path.endsWith('jpg') ||
                          item.path.endsWith('jpeg'))
                      .toList();
                  return snapshotImages.isEmpty
                      ? Column(
                          children: [
                            OutlinedButton(
                                onPressed: _saveImage,
                                child:
                                    const Text('Dodaj nowy plik osadzonego')),
                          ],
                        )
                      : Column(children: [
                          OutlinedButton(
                              onPressed: _saveImage,
                              child: const Text('Dodaj nowy plik osadzonego')),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(color: Colors.grey),
                              itemCount: snapshotImages.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(
                                    snapshotImages[index].path.split('/').last),
                                trailing: IconButton(
                                  onPressed: () => _deleteFile(
                                      fileEntity: snapshotImages[index],
                                      ads: false),
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ]);
                }),
            FutureBuilder(
                future: _getAds(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FileSystemEntity>?> snapshot) {
                  return Column(
                    children: [
                      OutlinedButton(
                          onPressed: _saveAd,
                          child: const Text('Dodaj nowy plik reklamowy')),
                      snapshot.data == null || snapshot.data!.isEmpty
                          ? Container()
                          : Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(color: Colors.grey),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(snapshot.data![index].path
                                      .split('/')
                                      .last),
                                  trailing: IconButton(
                                    onPressed: () => _deleteFile(
                                        fileEntity: snapshot.data![index],
                                        ads: true),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
