import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'List/images_list.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _formKey = GlobalKey<FormState>();
  var _image;
  bool isLoading = false;
  final nameController = TextEditingController();
  CollectionReference images = FirebaseFirestore.instance.collection("images");
  Reference ref = FirebaseStorage.instance.ref();

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
              ElevatedButton(child: Text("Загрузить"), onPressed: getImage),
              _image == null
                  ? Text('Картинка не выбрана.', textAlign: TextAlign.center)
                  : Image.file(
                      _image,
                      height: 300,
                    ),
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
                        if (_image != null) {
                          setState(() {
                            this.isLoading = true;
                          });
                          TaskSnapshot addImg = await ref
                              .child("image/" + nameController.text)
                              .putFile(_image);
                          if (addImg.state == TaskState.success) {
                            setState(() {
                              this.isLoading = false;
                            });
                            final String downloadUrl =
                                await addImg.ref.getDownloadURL();

                            await images.add({
                              'url': downloadUrl,
                              'name': nameController.text
                            });
                            setState(() {
                              this.isLoading = false;
                            });
                            print("Добавлено");
                            nameController.clear();
                            _image = null;
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
                              ListImages(title: "Список картинок", id: null)),
                    );
                  }),
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
    final _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }
}
