import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/Utils/helpers.dart';

class ListActs extends StatefulWidget {
  ListActs({Key? key, this.title, this.event, this.acts, this.accessories})
      : super(key: key);
  final title;
  final event;
  final acts;
  final accessories;

  @override
  _ListActs createState() => _ListActs();
}

class _ListActs extends State<ListActs> {
  final acts = FirebaseFirestore.instance.collection("acts");
  var finish = false;
  @override
  void initState() {
    super.initState();

    Future(() async {
      CollectionReference qqq;
      dynamic i = 0, xxx;
      if (widget.event != null) {
        await acts
            .where('event', isEqualTo: widget.event)
            .get()
            .then((value) async {
          for (var val in value.docs) {
            i = i + 1;
            print(i.toString());

            xxx = await accessoryValue(val.id);
            qqq = val.reference.collection('accessory');
            var element = await qqq.get();
            await acts.doc(val.id).update({'badAcc': 0, 'accessories': xxx});
            for (var val1 in element.docs) {
              if ((val1.data() as dynamic)!['accId'] == '') {
                await acts.doc(val.id).update({'badAcc': 1});
                break;
              }
            }
          }
        });
      } else {
        await acts.get().then((value) async {
          for (var val in value.docs) {
            i = i + 1;
            print(i.toString());

            xxx = await accessoryValue(val.id);
            qqq = val.reference.collection('accessory');
            var element = await qqq.get();
            await acts.doc(val.id).update({'badAcc': 0, 'accessories': xxx});
            for (var val1 in element.docs) {
              if ((val1.data() as dynamic)!['accId'] == '') {
                await acts.doc(val.id).update({'badAcc': 1});
                break;
              }
            }
          }
        });
      }
    }).then((value) {
      setState(() {
        finish = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
            finish ? Text('Проверка закончена') : CircularProgressIndicator());
  }
}
