import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/detail_page.dart';
import 'package:flutter_tesis_app/utils/loading_screen.dart';

class SelectListWidget extends StatelessWidget{
  final Stream<QuerySnapshot> stream;
  final String serviceName;
  const SelectListWidget({this.stream, this.serviceName});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
            stream: stream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                List<QueryDocumentSnapshot> list = snapshot.data.docs;
                  return list.isEmpty 
                  ? Center(child: const Text("No se encontraron Registros"),)
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        List _images = list[index]['images'];
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
                            leading: _images[0] == ""
                            ? Container(
                                height: 60,
                                width: 70,
                                child: Icon(Icons.image, size: 40,),
                              ) 
                            : Container(
                              height: 60,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _images[0],
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
                                            nameServices: serviceName,
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
    );
  }
}