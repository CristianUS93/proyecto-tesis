import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/detail_page.dart';

class FavoritosListWidget extends StatelessWidget {
 final List<QueryDocumentSnapshot> list;
 const FavoritosListWidget({this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: list.isEmpty
            ? Center(
              child: const Text("Aun no tienes favoritos para esta categoria"),
            )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  List images = list[index]['images'];
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
                      leading: images[0] == "" 
                      ? Container(
                        height: 60,
                        width: 70,
                        child: Icon(Icons.image),
                      )
                      : Container(
                        height: 60,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              images[0],
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
                                    )));
                      },
                    ),
                  );
                }),
      ),
    );
  }
}
