import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  State<AdsCarousel> createState() => _AdscarouselState();
}

class _AdscarouselState extends State<AdsCarousel> {
  Future<List<FileSystemEntity>> _getAd() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> list =
        Directory('${directory.path}/ads').listSync();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: _getAd(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FileSystemEntity>?> snapshot) {
          return snapshot.data == null || snapshot.data!.isEmpty
              ? Container()
              : IgnorePointer(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      height: height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      // autoPlay: false,
                    ),
                    items: snapshot.data!
                        .map((item) => Center(
                                child: Image.file(
                              File(item.path),
                              fit: BoxFit.contain,
                              height: height,
                            )))
                        .toList(),
                  ),
                );
        });
  }
}
