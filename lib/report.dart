import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  final types = FirebaseFirestore.instance.collection("types");
  final subtypes = FirebaseFirestore.instance.collection("subtypes");
  final events = FirebaseFirestore.instance.collection("events");
  final acts = FirebaseFirestore.instance.collection("acts");
  final admins = FirebaseFirestore.instance.collection("admins");
  var typesLists = [];
  var typesCount = [];
  var typesCountEvent = [];
  var typesCountAct = [];
  var typesListId = [];
  var subtypesLists = [];
  var subtypesCount = [];
  var subtypesCountAct = [];
  var subtypesListId = [];
  var eventsLists = [];
  var eventsCount = [];
  var eventsListId = [];
  var actsLists = [];
  var actsListId = [];
  var adminsList = [];
  List<String> adminsItems = [];
  var selectAdmin;
  var total;
  DateTime selectedDate = DateTime(2021);
  DateTime selectedDate2 = DateTime.now();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var _iter, _iter2;

      List _adminsLists = [];
      List<String> _adminsItems = [];
      await admins.get().then((querySnapshot) {
        querySnapshot.docs.forEach((values) {
          _adminsLists.add(values.data());
          _adminsItems.add(' ');
        });
      });

      List _typesLists = [];
      List _typesListId = [];
      List<int> _typesCount = [];
      List<int> _typesCountEvent = [];
      List<int> _typesCountAct = [];
      await types.get().then((querySnapshot) {
        querySnapshot.docs.forEach((values) {
          _typesLists.add(values.data());
          _typesListId.add(values.id);
          _typesCount.add(0);
          _typesCountEvent.add(0);
          _typesCountAct.add(0);
        });
      });

      List _subtypesLists = [];
      List _subtypesListId = [];
      List<int> _subtypesCount = [];
      List<int> _subtypesCountAct = [];
      await subtypes.get().then((querySnapshot) {
        querySnapshot.docs.forEach((values) {
          _subtypesLists.add(values.data());
          _subtypesListId.add(values.id);
          _subtypesCount.add(0);
          _subtypesCountAct.add(0);
        });
      });

      List _eventsLists = [];
      List _eventsListId = [];
      List<int> _eventsCount = [];
      await events.get().then((querySnapshot) {
        querySnapshot.docs.forEach((values) {
          _eventsLists.add(values.data());
          _eventsListId.add(values.id);
          _eventsCount.add(0);
        });
      });

      List _actsLists = [];
      List _actsListId = [];
      if (selectAdmin == null)
        await acts
            .where('datetime', isGreaterThanOrEqualTo: selectedDate)
            .where('datetime', isLessThanOrEqualTo: selectedDate2)
            .orderBy('datetime', descending: true)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((values) {
            _actsLists.add(values.data());
            _actsListId.add(values.id);
          });
        });
      else
        await acts
            .where('user', isEqualTo: selectAdmin)
            .where('datetime', isGreaterThanOrEqualTo: selectedDate)
            .where('datetime', isLessThanOrEqualTo: selectedDate2)
            .orderBy('datetime', descending: true)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((values) {
            _actsLists.add(values.data());
            _actsListId.add(values.id);
          });
        });

      for (_iter = 0; _iter < _adminsLists.length; _iter++) {
        _adminsItems[_iter] = _adminsLists[_iter]['email'].toString();
      }

      for (_iter = 0; _iter < _typesListId.length; _iter++) {
        _typesCount[_iter] = 0;
        for (_iter2 = 0; _iter2 < _subtypesListId.length; _iter2++) {
          _typesCount[_iter] = _typesCount[_iter] +
              (_subtypesLists[_iter2]['typeid'] == _typesListId[_iter] ? 1 : 0)
                  .toInt();
        }
      }

      for (_iter = 0; _iter < _subtypesListId.length; _iter++) {
        _subtypesCount[_iter] = 0;
        for (_iter2 = 0; _iter2 < _eventsListId.length; _iter2++) {
          _subtypesCount[_iter] = _subtypesCount[_iter] +
              (_eventsLists[_iter2]['subtype'] == _subtypesListId[_iter]
                      ? 1
                      : 0)
                  .toInt();
        }
      }

      for (_iter = 0; _iter < _eventsListId.length; _iter++) {
        _eventsCount[_iter] = 0;
        for (_iter2 = 0; _iter2 < _actsListId.length; _iter2++) {
          _eventsCount[_iter] = _eventsCount[_iter] +
              (_actsLists[_iter2]['event'] == _eventsListId[_iter] ? 1 : 0)
                  .toInt();
        }
      }

      for (_iter = 0; _iter < _subtypesListId.length; _iter++) {
        _subtypesCountAct[_iter] = 0;
        for (_iter2 = 0; _iter2 < _eventsListId.length; _iter2++) {
          _subtypesCountAct[_iter] = _subtypesCountAct[_iter] +
              (_eventsLists[_iter2]['subtype'] == _subtypesListId[_iter]
                      ? _eventsCount[_iter2]
                      : 0)
                  .toInt();
        }
      }
      var _total = 0;
      for (_iter = 0; _iter < _typesListId.length; _iter++) {
        _typesCountAct[_iter] = 0;
        for (_iter2 = 0; _iter2 < _subtypesListId.length; _iter2++) {
          _typesCountAct[_iter] = _typesCountAct[_iter] +
              (_subtypesLists[_iter2]['typeid'] == _typesListId[_iter]
                      ? _subtypesCountAct[_iter2]
                      : 0)
                  .toInt();
          _typesCountEvent[_iter] = _typesCountEvent[_iter] +
              (_subtypesLists[_iter2]['typeid'] == _typesListId[_iter]
                      ? _subtypesCount[_iter2]
                      : 0)
                  .toInt();
          _total = _total +
              (_subtypesLists[_iter2]['typeid'] == _typesListId[_iter]
                      ? _subtypesCountAct[_iter2]
                      : 0)
                  .toInt();
        }
      }

      setState(() {
        adminsItems = _adminsItems;
        typesLists = _typesLists;
        typesListId = _typesListId;
        typesCount = _typesCount;
        typesCountEvent = _typesCountEvent;
        typesCountAct = _typesCountAct;
        subtypesLists = _subtypesLists;
        subtypesListId = _subtypesListId;
        subtypesCount = _subtypesCount;
        subtypesCountAct = _subtypesCountAct;
        eventsLists = _eventsLists;
        eventsListId = _eventsListId;
        eventsCount = _eventsCount;
        actsLists = _actsLists;
        actsListId = _actsListId;
        total = _total;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Всего действий: ' + ' ' + total.toString()),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Row(children: [
            DropdownButton(
                value: selectAdmin,
                items:
                    adminsItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectAdmin = value.toString();
                    initState();
                  });
                },
                isExpanded: false,
                hint: selectAdmin == null
                    ? Text('Все администраторы',
                        style: TextStyle(color: Colors.blue))
                    : Text(
                        selectAdmin.toString(),
                        style: TextStyle(color: Colors.blue),
                      )),
            selectAdmin != null
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        selectAdmin = null;
                        initState();
                      });
                    },
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                  )
                : Container()
          ]),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectDate(context);
                      });
                    }, // Refer step 3
                    child: Text(DateFormat("dd-MMMM-yyyy", 'ru-RU')
                        .format(selectedDate)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 5),
                  ),
                ],
              ),
              Text('  _  '),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectDate2(context);
                      });
                    }, // Refer step 3
                    child: Text(DateFormat("dd-MMMM-yyyy", 'ru-RU')
                        .format(selectedDate2)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.grey,
                        elevation: 5),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: typesLists.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    title: Text(
                        typesLists[index]["name"] +
                            ',  ' +
                            typesCount[index].toString() +
                            ',  ' +
                            typesCountEvent[index].toString() +
                            ',  ' +
                            typesCountAct[index].toString(),
                        textAlign: TextAlign.justify),
                    children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: subtypesLists.length,
                          itemBuilder: (BuildContext context, int index2) {
                            return subtypesLists[index2]['typeid'] ==
                                    typesListId[index]
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                    child: ExpansionTile(
                                      title: Text(
                                          subtypesLists[index2]["name"] +
                                              ',  ' +
                                              subtypesCount[index2].toString() +
                                              ',  ' +
                                              subtypesCountAct[index2]
                                                  .toString(),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle()),
                                      children: <Widget>[
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: eventsLists.length,
                                            itemBuilder: (BuildContext context,
                                                int index3) {
                                              return eventsLists[index3]
                                                          ['subtype'] ==
                                                      subtypesListId[index2]
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              50, 0, 0, 0),
                                                      child: ExpansionTile(
                                                        title: Text(
                                                            eventsLists[index3]
                                                                    ["name"] +
                                                                ',  ' +
                                                                eventsCount[
                                                                        index3]
                                                                    .toString(),
                                                            textAlign: TextAlign
                                                                .justify),
                                                        children: <Widget>[
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  actsListId
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index4) {
                                                                return actsLists[index4]
                                                                            [
                                                                            'event'] ==
                                                                        eventsListId[
                                                                            index3]
                                                                    ? Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            50,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child: Column(
                                                                            children: [
                                                                              actsLists[index4]["name"] == "" ? Text('Без названия', style: TextStyle(fontWeight: FontWeight.bold)) : Text(actsLists[index4]["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                                                                              Text(actsLists[index4]["description"] + ('\n'))
                                                                            ]))
                                                                    : Container();
                                                              }),
                                                        ],
                                                      ))
                                                  : Container();
                                            }),
                                      ],
                                    ))
                                : Container();
                          }),
                    ],
                  );
                }),
          )
        ])));
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        initState();
      });
  }

  _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate2 = picked;
        initState();
      });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
