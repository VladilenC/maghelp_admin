import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:async';
import 'package:mime_type/mime_type.dart';
import 'List/accessory_list.dart';
import 'package:path/path.dart' as Path;

class MyPic3 extends StatefulWidget {
  MyPic3({Key? key, this.accessories}) : super(key: key);
  final accessories;

  @override
  _MyPic3State createState() => _MyPic3State();
}

class _MyPic3State extends State<MyPic3> {
  final _formKey = GlobalKey<FormState>();
  var _web2;
  var _uiWeb;
  var _media;
  bool isLoading = false;
  final nameController = TextEditingController();
  CollectionReference accessories =
      FirebaseFirestore.instance.collection("accessories");
  final ref = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              TextField(
                controller: nameController,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Введите название аксессуара',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(height: 5.0),
              _web2 == null
                  ? Text('Картинка не выбрана.', textAlign: TextAlign.center)
                  : _web2,
              SizedBox(
                height: 5.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                    child: Text("Выбор картинки"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: getImage)
              ]),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                !isLoading
                    ? ElevatedButton(
                        child: Text("Сохранить"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                        onPressed: () async {
                          if (_web2 != null) {
                            var mimeType =
                                mime(Path.basename(_media.fileName.toString()));
                            final extension =
                                extensionFromMime(mimeType.toString());
                            dynamic storageReference = ref.child("accessory/" +
                                nameController.text +
                                ".$extension");
                            /*
                            var metadata = storageReference.UploadMetadata(
                              contentType: mimeType,
                            );

                             */
                            var addImg = await storageReference
                                .putData(_uiWeb);
                            setState(() {
                              this.isLoading = true;
                            });
                            if (addImg.state == TaskState.success) {
                              final downloadUrl =
                                  await storageReference.getDownloadURL();
                              setState(() {
                                this.isLoading = false;
                              });
                              await accessories.add({
                                'url': downloadUrl.toString(),
                                'name': nameController.text
                              });
                              // setState(() {
                              //   this.isLoading = false;
                              // });
                              print("Добавлено");
                              nameController.clear();
                              _web2 = null;
                              _media = null;
                            }
                          }
                        })
                    : CircularProgressIndicator(),
                ElevatedButton(
                    child: Text("Список"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListAccessories(title: "Список аксессуаров", accessories: widget.accessories)),
                      );
                    }),
              ]),
              SizedBox(height: 10)
            ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future getImage() async {
    dynamic mediaInfo = await ImagePickerWeb.getImageInfo;
    //String? mimeType = mime(Path.basename(mediaInfo.fileName));
    setState(() {
      _media = mediaInfo;
      _uiWeb = mediaInfo.data;
      _web2 = Image.memory(mediaInfo.data);
    });

  }
}
