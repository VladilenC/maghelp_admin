import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'images_list.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  File _image;
  bool isLoading = false;
  bool isRetrieved = false;
  QuerySnapshot cachedResult;
  final nameController = TextEditingController();

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
                    borderRadius: BorderRadius.circular(10.0)
                )
            ),
          ),
          SizedBox(height: 5.0),
          /// TODO: cache images correctly
          ElevatedButton(child: Text("Загрузить"), onPressed: getImage),
          _image == null
              ? Text('Картинка не выбрана.')
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
                      Reference ref = FirebaseStorage.instance.ref();
                      TaskSnapshot addImg =
                          await ref.child("image/"+nameController.text).putFile(_image);
                      if (addImg.state == TaskState.success) {
                        setState(() {
                          this.isLoading = false;
                        });
                        final String downloadUrl = await addImg.ref.getDownloadURL();

                        await FirebaseFirestore.instance
                            .collection('images')
                            .add({'url': downloadUrl, 'name': nameController.text});
                        setState(() {
                          this.isLoading = false;
                        });
                        print("Добавлено");
                        nameController.clear();
                        _image=null;
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
                      builder: (context) => ListImages(title: "Список картинок")),
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
    var image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  Future<QuerySnapshot> getImages() {
    print('333');
    return fb.collection("images").get();
  }

  ListView displayCachedList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cachedResult.docs.length,
        itemBuilder: (BuildContext context, int index) {
          print(cachedResult.docs[index].data()["url"]);
          print('111');
          print(isRetrieved);
          print(cachedResult.docs.length);
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(cachedResult.docs[index].data()["name"]),
            leading: Image.network(cachedResult.docs[index].data()["url"],
                fit: BoxFit.fill),
          );
        });
  }
}
