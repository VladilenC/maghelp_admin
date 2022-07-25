import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageEdit1 extends StatefulWidget {
  ImageEdit1({Key? key, this.nom, this.id, this.name, this.title, this.url})
      : super(key: key);
  final dynamic title;
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;

  @override
  _ImageEdit1 createState() => _ImageEdit1();
}

class _ImageEdit1 extends State<ImageEdit1> {
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
              Text("Измените картинку",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              ImageEdit(
                  nom: widget.nom,
                  url: widget.url,
                  id: widget.id,
                  name: widget.name),
            ]),
      )),
    );
  }
}

class ImageEdit extends StatefulWidget {
  ImageEdit({Key? key, this.nom, this.id, this.name, this.url})
      : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic url;

  @override
  _ImageEditState createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  var _url;
  var _nameController0;
  CollectionReference images = FirebaseFirestore.instance.collection("images");

  @override
  Widget build(BuildContext context) {
    final _nameController = _nameController0 != null
        ? _nameController0
        : TextEditingController(text: widget.name);

    return Form(
        key: _formKey2,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _nameController,
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
              child: _url != null
                  ? CachedNetworkImage(
                      imageUrl: _url,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  //             Image.network(_url)
                  : widget.url != null
                      ? CachedNetworkImage(
                          imageUrl: widget.url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      //          Image.network(widget.url)
                      : Text('Нет картинки')),
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
                  onPressed: () {
                    setState(() {});
                    if (_formKey2.currentState!.validate()) {
                      images.doc(widget.id).update({
                        "name": _nameController.text.toString().trim(),
                      }).then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Сохранено')));
                        nameController.clear();
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                      });
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
}
