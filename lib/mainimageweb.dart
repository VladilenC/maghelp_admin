import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase.dart' as Firebase;
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:async';
import 'List/images_list.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

class MyPic extends StatefulWidget {
  MyPic({Key? key}) : super(key: key);

  @override
  _MyPicState createState() => _MyPicState();
}

class _MyPicState extends State<MyPic> {
  final _formKey = GlobalKey<FormState>();
  var _web2;
  var _uiWeb;
  var _media;
  bool isLoading = false;
  final nameController = TextEditingController();
  CollectionReference images = FirebaseFirestore.instance.collection("images");
  final ref = Firebase.storage().ref();

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
                        labelText: 'Введите название',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  SizedBox(height: 5.0),
                  _web2 == null
                      ? Text('Картинка не выбрана.',
                          textAlign: TextAlign.center)
                      : _web2,
                  SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            child: Text("Выбор картинки"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue,
                              onPrimary: Colors.white,
                              shadowColor: Colors.grey,
                              elevation: 5,
                            ),
                            onPressed: getImage),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                                        mime(Path.basename(_media.fileName));
                                    final extension =
                                        extensionFromMime(mimeType!);
                                    Firebase.StorageReference storageReference =
                                        ref.child("image/" +
                                            nameController.text +
                                            ".$extension");
                                    var metadata = Firebase.UploadMetadata(
                                      contentType: mimeType,
                                    );
                                    var addImg = await storageReference
                                        .put(_uiWeb, metadata)
                                        .future;
                                    setState(() {
                                      this.isLoading = true;
                                    });
                                    if (addImg.state ==
                                        Firebase.TaskState.SUCCESS) {
                                      final downloadUrl = await storageReference
                                          .getDownloadURL();
                                      setState(() {
                                        this.isLoading = false;
                                      });
                                      await images.add({
                                        'url': downloadUrl.toString(),
                                        'name': nameController.text
                                      });
                                      setState(() {
                                        this.isLoading = false;
                                      });
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
                                    builder: (context) => ListImages(
                                        title: "Список картинок", id: 1)),
                              );
                            }),
                      ]),
                  SizedBox(height: 10)
                ])));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future getImage() async {
    MediaInfo? mediaInfo = await ImagePickerWeb.getImageInfo;
    setState(() {
      _media = mediaInfo;
      _uiWeb = mediaInfo?.data;
      _web2 = Image.memory(mediaInfo!.data!);
    });
  }
}
