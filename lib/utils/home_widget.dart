import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/pages/services_page.dart';


class HomeWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context){
    final String restaurant = "restaurante";
    final String hotel = "hoteles";
    final String turistico = "lugaresTuristicos";
    final String tiendas = "tiendas";

    return Flex(
      direction: Axis.vertical,
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
              context,
              "RESTAURANTES",
              Icons.restaurant,
              restaurant
            ),
            cardMenu(
              context,
              "HOTELES",
              Icons.hotel,
              hotel
            ),
            cardMenu(
              context,
              "TIENDAS",
              Icons.store,
              tiendas
            ),
            cardMenu(
              context,
              "SITIOS TURISTICOS",
              Icons.travel_explore,
              turistico
            ),
          ],
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  GestureDetector cardMenu(BuildContext context, String title, IconData icon, String nameCollection) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection(nameCollection).snapshots();
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
            StreamBuilder(
              stream: _stream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                return snapshot.hasData 
                ? Text(snapshot.data.docs.length.toString() + " lugares")
                : Text("0 lugares");
              }
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ServicesPage(title: title, servicesName: nameCollection,)
        ));
      },
    );
  }
}