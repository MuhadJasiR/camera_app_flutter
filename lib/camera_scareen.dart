import 'dart:io';
import 'package:camera_app_flutter/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List> db = ValueNotifier([]);

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ValueListenableBuilder(
          valueListenable: db,
          builder: (context, List data, text) {
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisExtent: 30,
              ),
              children: List.generate(
                data.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ImageScreen(
                                  image: data[index],
                                ))),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(
                            File(
                              data[index].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cameraButton();
        },
        child: Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}

void cameraButton() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
  if (image == null) {
    return;
  } else {
    Directory? directory = await getExternalStorageDirectory();
    File imagepath = File(image.path);

    await imagepath.copy('${directory!.path}/${DateTime.now()}.png');

    getItems(directory);
  }
}

getItems(Directory directory) async {
  final listDir = await directory.list().toList();
  db.value.clear();
  for (var i = 0; i < listDir.length; i++) {
    if (listDir[i].path.substring(
            (listDir[i].path.length - 4), (listDir[i].path.length)) ==
        '.jpg') {
      db.value.add(listDir[i].path);
      db.notifyListeners();
    }
  }
}
