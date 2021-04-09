import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database_tutorial/types_edit.dart';

final typesInstance = FirebaseFirestore.instance;

getTypes() async {

  List listTypes = [];

    await typesInstance.collection('types').get().then((querySnapshot) {

      querySnapshot.docs.forEach((element) {

        listTypes.add(element.data()['type']);

      });


    });
    print('000');

print(listTypes);
    return listTypes;
  }
