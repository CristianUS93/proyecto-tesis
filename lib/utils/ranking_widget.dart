import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/utils/list_view_widget.dart';
import 'package:flutter_tesis_app/utils/loading_screen.dart';

class RankingWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> list;
  final bool loading;

  const RankingWidget({this.list, this.loading});

  @override
  _RankingWidgetState createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.loading
          ? LoadingScreen()
          : ListViewWidget(list: widget.list,),
    );
  }
}
