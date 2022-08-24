import 'package:maghelp_add_act/maintype.dart';
import 'package:maghelp_add_act/mainsubtype.dart';
import 'package:maghelp_add_act/mainevent.dart';
import 'package:maghelp_add_act/mainact.dart';
import 'package:maghelp_add_act/mainimageweb.dart';
import 'package:maghelp_add_act/mainpictureweb.dart';
import 'package:maghelp_add_act/mainaccessory.dart';
import 'moon_list.dart';
import 'package:flutter/material.dart';
import 'report.dart';

class AppMenu extends StatefulWidget {
  AppMenu({Key? key, this.user,this.acts, this.accessories}) : super(key: key);
  final user, acts, accessories;

  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'События',
        home: DefaultTabController(
          length: 9,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Магическая помощь'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Типы'),
                  Tab(text: 'Подтипы'),
                  Tab(text: 'События'),
                  Tab(text: 'Действия'),
                  Tab(text: 'Картинки'),
                  Tab(text: 'Картинки в тексте'),
                  Tab(text: 'Аксессуары'),
                  Tab(text: 'Календарь'),
                  Tab(text: 'Отчеты'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                MyType(),
                MySubType(),
                MyEvent(),
                MyAct(user: widget.user,acts: widget.acts, accessories: widget.accessories),
                MyPic(),
                MyPic2(),
                MyPic3(accessories: widget.accessories),
                ListMoon(),
                MyReport(),
              ],
            ),
          ),
        ));
  }
}
