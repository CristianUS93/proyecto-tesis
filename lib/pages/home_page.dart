import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_tesis_app/main.dart';
import 'package:flutter_tesis_app/pages/hoteles_page.dart';
import 'package:flutter_tesis_app/pages/restaurantes_page.dart';
import 'package:flutter_tesis_app/pages/sitios_turisticos_page.dart';
import 'package:flutter_tesis_app/pages/tiendas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QARWASH",
        ),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: Icon(Icons.person),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar Sesión"),
            onTap: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => LandingPage()),
                  (route) => false);
            },
          )
        ],
      )),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cardsMenuBody(),
            ],
          ),
        ),
      ),
    );
  }

  Column cardsMenuBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardMenu("RESTAURANTES", Icons.restaurant, RestaurantesListPage()),
            cardMenu("HOTELES", Icons.hotel, HotelesListPage()),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardMenu("TIENDAS", Icons.store, TiendasListPage()),
            cardMenu("SITIOS TURISTICOS", Icons.travel_explore,
                SitiosTuristicosListPage()),
          ],
        ),
      ],
    );
  }

  GestureDetector cardMenu(String title, IconData icon, Widget page) {
    return GestureDetector(
      child: Container(
        height: 110,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 5),
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
