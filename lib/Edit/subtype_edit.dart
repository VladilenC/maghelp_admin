import 'package:cloud_firestore/cloud_firestore.dart';
import '../List/images_list.dart';
import 'package:flutter/material.dart';


class SubEdit1 extends StatefulWidget {
  SubEdit1({Key key, this.nom, this.id, this.name, this.type, this.title, this.url, this.description}) : super(key: key);
  final dynamic title;
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic type;
  final dynamic url;
  final dynamic description;

  @override
  _SubEdit1 createState() => _SubEdit1();
}

class _SubEdit1 extends State<SubEdit1> {
  final subtypes = FirebaseFirestore.instance.collection("subtypes");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title+': '+widget.name),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Измените подтип",
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic)),
              SubEdit(nom: widget.nom, url: widget.url, id: widget.id, name: widget.name, type: widget.type, description: widget.description),
            ]),
      )),
    );
  }
}

class SubEdit extends StatefulWidget {
  SubEdit({Key key, this.nom, this.id, this.name, this.type, this.description, this.url}) : super(key: key);
  final dynamic nom;
  final dynamic id;
  final dynamic name;
  final dynamic type;
  final dynamic description;
  final dynamic url;



  @override
  _SubEditState createState() => _SubEditState();
}

class _SubEditState extends State<SubEdit> {
  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  var _url;
  var _pic;
  var _nameController0;

  @override
  Widget build(BuildContext context) {
    CollectionReference  subtypes = FirebaseFirestore.instance.collection("subtypes");

    final _nameController = _nameController0!=null ? _nameController0 : TextEditingController(text: widget.name);

    final _typeController = TextEditingController(text: widget.type);
    final _descriptionController = TextEditingController(text: widget.description);


    return Form(
        key: _formKey2,
    child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _typeController,
              enabled: false,
              decoration: InputDecoration(
                labelText: "Тип",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Тип обязателен';
                }
                return null;
              },
            ),
          ),

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
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Название обязательно';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: _descriptionController,
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: "Описание",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            Padding(
            padding: EdgeInsets.all(5.0),
              child: _url!=null ? Image.network(_url) : widget.url!=null ? Image.network(widget.url):Text('Нет картинки')),
             Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      child: Text("Выбор картинки"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 5,
                      ),
                      onPressed: () async {

                        var _url0 = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListImages(title: "Выбор картинки", id: null)),
                        );                        setState(() {
_url = _url0['url'];
_pic = _url0['pic'];
_nameController0 = _nameController;
                        });

                      }),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {

                      });
                      if (_formKey2.currentState.validate()) {
                        dynamic i = int.parse(widget.nom)+1;
;                        subtypes.doc(widget.id).update({
                          "name": _nameController.text,
                          "description": _descriptionController,
                          "url": _url!=null ? _url : widget.url,
 //                         "pic": _url!=null ? _pic : null
                         // "subtype": _subtypeController.text
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Сохранено')));
                          typeController.clear();
                          nameController.clear();
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(onError)));
                        });

                      }
                      Navigator.pop(
                        context
                      );
                    },
                    child: Text('Сохранить'),
                  ),
//                  ElevatedButton(
//                    style: ElevatedButton.styleFrom(
//                      primary: Colors.amber,
//                      onPrimary: Colors.white,
//                      shadowColor: Colors.grey,
//                      elevation: 5,
//                    ),
//                    onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ListEvents(title: "Home Page")),
//                      );
//                    },
//                    child: Text('Отмена'),
//                  ),
                ],
              ),

          ),
        ])));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    typeController.dispose();
    descriptionController.dispose();
  }
}
