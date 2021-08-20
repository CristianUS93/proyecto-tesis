import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/detail_page.dart';
import 'package:flutter_tesis_app/utils/loading_screen.dart';

class ServicesPage extends StatefulWidget {
  final String servicesName;
  final String title;
  const ServicesPage({
    Key key,
    this.title,
    this.servicesName,
  }) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection(widget.servicesName).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: _stream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                List<QueryDocumentSnapshot> list = snapshot.data.docs;
                  return ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: list.length,
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
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
                                    list[index]['images'][0],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              list[index]['nombre'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing:
                                Text(list[index]['like'].toString() + ' Likes'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailPage(
                                            doc: list[index],
                                            index: index,
                                            nameServices: widget.servicesName,
                                          )));
                            },
                          ),
                        );
                      });
              }else{
                return LoadingScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}

