import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

class AccessoryEdit1 extends StatefulWidget {
  AccessoryEdit1({Key? key, this.nom, this.id, this.name, this.title, this.url})
      : super(key: key);
  final dynamic title;
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;

  @override
  _AccessoryEdit1 createState() => _AccessoryEdit1();
}

class _AccessoryEdit1 extends State<AccessoryEdit1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ': ' + widget.name),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Измените аксессуар",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              AccessoryEdit(
                  nom: widget.nom,
                  url: widget.url,
                  id: widget.id,
                  name: widget.name),
            ]),
      )),
    );
  }
}

class AccessoryEdit extends StatefulWidget {
  AccessoryEdit({Key? key, this.nom, this.id, this.name, this.url})
      : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;


  @override
  _AccessoryEditState createState() => _AccessoryEditState();
}

class _AccessoryEditState extends State<AccessoryEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
 // var _url;
 // var _nameController0;
  CollectionReference accessories =
  FirebaseFirestore.instance.collection("accessories");
  final ref = FirebaseStorage.instance.ref();
  var _web2;
  var _uiWeb;
  var _media;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {

    final nameController = TextEditingController(text: widget.name);

    return Form(
        key: _formKey2,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Название",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Название обязательно';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: _web2 != null
                  ? _web2
              /*
              CachedNetworkImage(
                      imageUrl: _web2,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )

               */
//              Image.network(_url)
                  : widget.url != null
                      ? CachedNetworkImage(
                          imageUrl: widget.url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      //            Image.network(widget.url)
                      : Text('Нет картинки')),

              ElevatedButton(
                  child: Text("Выбор картинки"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  onPressed: getImage),



          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  onPressed: () async {
           //         setState(() {});
                    if (_formKey2.currentState!.validate()) {

                      if (_web2 != null) {
                        var mimeType =
                        mime(Path.basename(_media.fileName.toString()));
                        final extension =
                        extensionFromMime(mimeType.toString());
                        dynamic storageReference = ref.child("accessory/" +
                            nameController.text +
                            ".$extension");
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
                          await accessories.doc(widget.id).update({
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
else {
                        accessories.doc(widget.id).update({
                          "name": nameController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                              SnackBar(content: Text('Сохранено')));
                          nameController.clear();
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });
                      }
                    }




                    Navigator.pop(context);
                  },
                  child: Text('Сохранить'),
                ),
              ],
            ),
          ),
        ])));
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
}
