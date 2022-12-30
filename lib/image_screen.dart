import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera_app_flutter/camera_scareen.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key, required this.image});
  final dynamic image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: db,
          builder: (context, List data, _) {
            return Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Image.file(
                  File(image.toString()),
                ),
              ),
            );
          }),
    );
  }
}
