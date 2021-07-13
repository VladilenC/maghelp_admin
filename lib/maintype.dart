import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'List/types_list.dart';
import 'List/images_list.dart';


class MyType extends StatefulWidget {
  MyType({Key key}) : super(key: key);

  @override
  _MyTypeState createState() => _MyTypeState();
}

class _MyTypeState extends State<MyType> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference  types = FirebaseFirestore.instance.collection("types");
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var selectType, _url, url;
  List desItems, urlItems, nameItems, idItems;

  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
   body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('types').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null)
                            return
                              SizedBox(
                                  height: 36,
                                  width: 16,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      )

                                  ));

                          else {
                            List <DropdownMenuItem> typeItems = [];
                            desItems = [];
                            urlItems = [];
                            nameItems = [];
                            idItems =[];
                            for (int i = 0; i <
                                snapshot.data.docs.length; i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              typeItems.add(
                                DropdownMenuItem(
                                  child: Text(
                                    snap['name'],
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  value: "${snap.id}",
                                ),
                              );
                              snap['description'] != null ? desItems.add(snap['description']): desItems.add('');
                              snap['url'] != null ? urlItems.add(snap['url']): urlItems.add('');
                              snap['name'] != null ? nameItems.add(snap['name']): nameItems.add('');
                              snap.id != null ? idItems.add(snap.id): idItems.add('');
                 //             idItems.add(snap.id);
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.check,
                                  size: 25.0,
                                  color: Colors.blue,),
                                SizedBox(width: 50.0,),
                                DropdownButton<dynamic>(
                                  items: typeItems,
                                  onChanged: (typeValue){
                                    final snackBar = SnackBar(
                                      content: Text('Выбран тип $typeValue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    setState(() {
                                      selectType = typeValue;
                                      var _i = idItems.indexOf(typeValue);
                                      nameController.text = nameItems[_i];
                                      descriptionController.text = desItems[_i];
                                      url = urlItems[_i];
                                    });
                                  },
                                  value: selectType,
                                  isExpanded: false,
                                  hint: Text('Выберите тип',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                    SizedBox(height: 10.0),



TextFormField(
  controller: nameController,
    maxLines: 2,
    decoration: InputDecoration(
      labelText: 'Введите название',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0)
      )
    ),
),
                    SizedBox(height: 10.0),



                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Введите описание',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),

              Padding(
               padding: EdgeInsets.all(5.0),
   //             child: _url!=null ? Image.network(_url) : Text('Нет картинки')),
               child: _url!=null ? Image.network(_url) : (url != null ? Image.network(url): Text('Не выбрано',textAlign: TextAlign.center))
              ),

              Padding(
                padding: EdgeInsets.all(5.0),
                   child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     ElevatedButton(
                     child: Text("Выбор картинки"),
                      style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      ),
                    onPressed: () async {
                      var _url0 = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListImages(title: "Выбор картинки", id: null)),
                        );
                      setState(() {
_url = _url0['url'];
                      });
                  })])),
                    SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.teal,
                                          onPrimary: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                        ),
                                        onPressed: () {
                                          if (nameController.text!=null) {
                                         if (_formKey.currentState.validate()) {
                                            types.doc().set({
                                              "name": nameController.text,
                                              "description": descriptionController.text,
                                              'url': _url
                                            }).then((_) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Добавлено')));
                                              nameController.clear();
                                              selectType.clear();
                                              descriptionController.clear();
                                              _url = null;
                                            }).catchError((onError) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text(onError)));
                                            });
                                          }
                                        }
                                          else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Не добавлено. Название не может быть пустым')));
                                          }
                                          setState(() {
                          //                  _url = null;r
                                          });},
                                        child: Text('Добавить'),
                                      ),

                                      selectType != null ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.teal,
                                          onPrimary: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                        ),
                                        onPressed: () {
                                          if (nameController.text!=null) {
                                            if (_formKey.currentState.validate()) {
                                              types.doc(selectType).update({
                                                "name": nameController.text,
                                                "description": descriptionController.text,
                                                'url': _url != null ? _url: url,
                                              }).then((_) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Изменено')));
                                                nameController.clear();
                                                selectType.clear();
                                                descriptionController.clear();
                                                _url = null;
                                              }).catchError((onError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text(onError)));
                                              });
                                            }
                                          }
                                          else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Не изменено. Название не может быть пустым')));
                                          }
                                          setState(() {
                                            //                  _url = null;
                                          });},
                                        child: Text('Изменить'),
                                      ):Text(''),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.amber,
                                          onPrimary: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ListTypes(title: "Список типов")),
                                          );
                                        },
                                        child: Text('Список'),
                                      ),
                                    ],
                                  ),
                  ]
                  )
              )
          );
    }

  @override
  void dispose() {
    super.dispose();
  //  nameController.dispose();
  }
}
