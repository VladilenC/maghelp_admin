
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase.dart' as Firebase;
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:async';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'List/accessory_list.dart';
import 'package:path/path.dart' as Path;


class MyPic3 extends StatefulWidget {
  MyPic3({Key key}) : super(key: key);

  @override
  _MyPic3State createState() => _MyPic3State();
}

class _MyPic3State extends State<MyPic3> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  File _image;
  Image _web;
  Image _web2;
  Uint8List _uiWeb;
  MediaInfo _media;
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
                labelText: 'Введите название аксессуара',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                )
            ),
          ),
          SizedBox(height: 5.0),
          /// TODO: cache images correctly
          ElevatedButton(child: Text("Загрузить"), onPressed: getImage),
          _web2 == null
              ? Text('Картинка не выбрана.',textAlign: TextAlign.center)
              : _web2,



          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              !isLoading ?
              ElevatedButton(
                  child: Text("Сохранить"),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                onPrimary: Colors.white,
                shadowColor: Colors.grey,
                elevation: 5,
              ),
                  onPressed: () async {
                    if (_web2 != null) {
                      Reference ref = FirebaseStorage.instance.ref();

                      String mimeType = mime(Path.basename(_media.fileName));
                      final String extension = extensionFromMime(mimeType);
                      Firebase.StorageReference storageReference =
                      Firebase.storage().ref().child("accessory/"+nameController.text + ".$extension");

                      var metadata = Firebase.UploadMetadata(
                        contentType: mimeType,
                      );


                      var addImg = await storageReference.put(_uiWeb, metadata).future;

                      setState(() {
                        this.isLoading = true;
                      });

                      if (addImg.state == Firebase.TaskState.SUCCESS) {
                        final   downloadUrl = await storageReference.getDownloadURL();

                        setState(() {
                          this.isLoading = false;
                        });

                        await FirebaseFirestore.instance
                            .collection('accessories')
                            .add({'url': downloadUrl.toString(), 'name': nameController.text});
                        setState(() {
                          this.isLoading = false;
                        });
                        print("Добавлено");
                        nameController.clear();
                        _web2=null;
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
                      builder: (context) => ListAccessories(title: "Список аксессуаров")),
                );
              }
              ),])

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
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;

    setState(() {
      _media = mediaInfo;
      _uiWeb = mediaInfo.data;
      //     _web = image;
      _web2 = Image.memory(mediaInfo.data);
    });
  }

  Future<QuerySnapshot> getImages() {
    print('333');
    return fb.collection("accessories").get();
  }

  ListView displayCachedList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cachedResult.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(cachedResult.docs[index]["name"]),
            leading: Image.network(cachedResult.docs[index]["url"],
                fit: BoxFit.fill),
          );
        });
  }
}