import 'dart:async';
import 'dart:developer' as devtools show log;
import 'dart:html';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final questions = FirebaseFirestore.instance.collection("questions");
final subscriptions = FirebaseFirestore.instance.collection("subscriptions");
final services = FirebaseFirestore.instance.collection("services");
final protection = FirebaseFirestore.instance.collection("protection");
final events = FirebaseFirestore.instance.collection("events");
final accessories = FirebaseFirestore.instance.collection("accessories");
final acts = FirebaseFirestore.instance.collection("acts");

bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;

void log(
  String screenId, {
  dynamic msg,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    devtools.log(
      msg.toString(),
      error: error,
      name: screenId,
      stackTrace: stackTrace,
    );

Future<num> isQuestions(String? uid) {
  dynamic qqq = 1;
  return Future(() async {
    dynamic query1 = await questions.where('uid', isEqualTo: uid).get();
    query1.docs.forEach((element) {
      qqq = qqq - 1;
    });
    dynamic query = await subscriptions.where('uid', isEqualTo: uid).get();
    for (var element in query.docs) {
      await services.doc(element.data()['serviceId']).get().then((result) {
        if (result.data()!['type'] == 'question') {
          qqq = qqq + result.data()!['value'] ?? 0;
        }
      });
    }
    return qqq < 0 ? 0 : qqq;
  });
}

Future<num> isTalismans(String? uid) {
  dynamic qqq = 1;
  return Future(() async {
    dynamic query1 = await protection.where('uid', isEqualTo: uid).get();
    query1.docs.forEach((element) {
      qqq = qqq - 1;
    });
    dynamic query = await subscriptions.where('uid', isEqualTo: uid).get();
    for (var element in query.docs) {
      await services.doc(element.data()['serviceId']).get().then((result) {
        if (result.data()!['type'] == 'protection') {
          qqq = qqq + result.data()!['value'] ?? 0;
        }
      });
    }
    return qqq < 0 ? 0 : qqq;
  });
}

Future<Timestamp> isAdvices(String? uid) {
  Timestamp qqq = Timestamp(DateTime.now().second, 0);
  return Future(() async {
    await subscriptions
        .where('uid', isEqualTo: uid)
        .orderBy('dateend', descending: true)
        .get()
        .then((query) {
      qqq = query.docs.first.data()['dateend'] ??
          Timestamp(DateTime.now().second, 0);
    });
    return qqq;
  });
}

Future<String> urlEvent(String? eventId) {
  dynamic qqq;
  return Future(() async {
    await events.doc(eventId).get().then((query) {
      qqq = (query.data() as dynamic)['url'];
    });
    return qqq;
  });
}

Future<String> subscriptionPayment(String? eventId) {
  dynamic qqq;
  return Future(() async {
    await subscriptions.doc(eventId).get().then((query) async {
      qqq = (query.data() as dynamic)['serviceId'];
      await services.doc(qqq).get().then((value) {
        qqq = (value.data() as dynamic)['name'];
      });
    });
    return qqq;
  });
}

Future<num> accessoryValue(String? actId) {
  dynamic qqq = 0;
  return Future(() async {
    await acts.doc(actId).get().then((query) async {
      await query.reference.collection('accessory').get().then((value) {
        if (value.size > 0) {
          qqq = value.size;
        }
      });
    });
    return qqq;
  });
}

Future<String> accessoryId(String? name) {
  return Future(() async {
    dynamic qqq = '';
    qqq = await accessories.where("name", isEqualTo: name).get().then((value) {
      if (value.size > 0) {
        qqq = value.docs.first.id;
        return qqq??'';
      }
      else {
        qqq = '';
        return qqq;
      }
    });
    return qqq??'';
  });
}

Future<String> accessoryName(String? id) {
  return Future(() async {
    dynamic qqq = '';
    qqq = await accessories.doc(id).get().then((value) {
      if (value.exists ) {
        qqq = value.data()!['name'];
        return qqq??'';
      }
      else {
        qqq = '';
        return qqq;
      }
    });
    return qqq??'';
  });
}

Future<String> accessoryUrl(String? id) {
  return Future(() async {
    dynamic qqq = '';
    qqq = await accessories.doc(id).get().then((value) {
      if (value.exists ) {
        qqq = value.data()!['url'];
        return qqq??'';
      }
      else {
        qqq = '';
        return qqq;
      }
    });
    return qqq??'';
  });
}