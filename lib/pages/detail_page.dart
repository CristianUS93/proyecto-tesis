import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_tesis_app/pages/map_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class DetailPage extends StatelessWidget {
  DocumentSnapshot doc;

  DetailPage({@required this.doc});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(doc['nombre']),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemCount: doc['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  doc['images'][index],
                  width: media.size.width,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              doc['nombre'],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
              IconButton(
                  onPressed: () async {
                    await Geolocator.requestPermission().then((value) async {
                      if (value == LocationPermission.always) {
                        Position position =
                            await Geolocator.getCurrentPosition();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MapPage(
                                      initPosition: position,
                                      finalPosition: LatLng(
                                        doc['latitud'],
                                        doc['longitud'],
                                      ),
                                    )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                "No se concedieron los permisos necesarios"),
                          ),
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.location_pin)),
              IconButton(onPressed: () {}, icon: Icon(Icons.thumb_down)),
            ],
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Text(
                    "DESCRIPCIÓN",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
