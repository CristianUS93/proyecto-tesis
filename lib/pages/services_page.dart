import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/utils/list_view_widget.dart';

class ServicesPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> list;
  final String title;
  const ServicesPage({
    Key key,
    this.title,
    this.list,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListViewWidget(list: list,),
    );
  }
}