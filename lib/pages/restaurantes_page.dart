import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/detail_page.dart';

class RestaurantesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    CollectionReference restfirebase =
        FirebaseFirestore.instance.collection('restaurante');

    return Scaffold(
        appBar: AppBar(
          title: Text("Restaurantes"),
        ),
        body: StreamBuilder(
          stream: restfirebase.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Hubo problemas al conectar"),
              );
            }

            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return Center(
                child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(
                          top: 15.0,
                          left: 20.0,
                        ),
                        leading: Image.network(
                          docs[index]['images'][0],
                          width: media.size.width * 0.2,
                          fit: BoxFit.cover,
                        ),
                        title: Text(docs[index]['nombre']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                        doc: docs[index],
                                      )));
                        },
                      );
                    }),
              );
            }

            return Center(child: Text("Loading"));
          },
        ));
  }
}
