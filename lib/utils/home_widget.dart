import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/services_page.dart';

class HomeWidget extends StatefulWidget{
  final List<QueryDocumentSnapshot> restaurant;
  final List<QueryDocumentSnapshot> hotel;
  final List<QueryDocumentSnapshot> siteTur;
  HomeWidget({this.restaurant, this.hotel, this.siteTur});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 30),
          width: double.infinity,
          child: const Text("BIENVENIDO,",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 40,),
          width: double.infinity,
          child: const Text("Seleccione el lugar que desea visitar.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(flex: 1, child: Container()),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          children: [
            cardMenu(
              "RESTAURANTES",
              Icons.restaurant,
              widget.restaurant,
            ),
            cardMenu(
              "HOTELES",
              Icons.hotel,
              widget.hotel,
            ),
            cardMenu(
              "TIENDAS",
              Icons.store,
              widget.hotel,
            ),
            cardMenu(
              "SITIOS TURISTICOS",
              Icons.travel_explore,
              widget.siteTur,
            ),
          ],
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  GestureDetector cardMenu(String title, IconData icon, List list) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 3),
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Colors.black, size: 60),
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${list.length} lugares', style: TextStyle(color: Color(0xff898989)),),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ServicesPage(title: title, list: list,)
        ));
      },
    );
  }
}