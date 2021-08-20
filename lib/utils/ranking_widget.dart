import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/detail_page.dart';
import 'package:flutter_tesis_app/utils/loading_screen.dart';

class RankingWidget extends StatefulWidget {
  @override
  _RankingWidgetState createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  final CollectionReference _rest =
      FirebaseFirestore.instance.collection("restaurante");
  final CollectionReference _hotel =
      FirebaseFirestore.instance.collection("hoteles");
  final CollectionReference _site =
      FirebaseFirestore.instance.collection("lugaresTuristicos");

  List<QueryDocumentSnapshot> _list = [];
  List<QueryDocumentSnapshot> _newList = [];


  getList() async {
    await _rest.get().then((value) => value.docs.forEach((element) {
          setState(() => _list.add(element));
        }));
    await _hotel.get().then((value) => value.docs.forEach((element) {
          setState(() => _list.add(element));
        }));
    await _site.get().then((value) => value.docs.forEach((element) {
          setState(() => _list.add(element));
        }));
    _list.forEach((element) {
      if(element['like']>=0){
        print(element['like']);
      }
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _list.isEmpty
            ? LoadingScreen()
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: Container(
                        height: 60,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              _list[index]['images'][0],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        _list[index]['nombre'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing:
                          Text(_list[index]['like'].toString() + ' Likes'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailPage(
                                      doc: _list[index],
                                    )));
                      },
                    ),
                  );
                }),
      ),
    );
  }
}
