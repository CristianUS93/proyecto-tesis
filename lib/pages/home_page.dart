import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tesis_app/pages/info_page.dart';
import 'package:flutter_tesis_app/pages/politics_page.dart';
import 'package:flutter_tesis_app/pages/profile_page.dart';
import 'package:flutter_tesis_app/utils/home_widget.dart';
import 'package:flutter_tesis_app/utils/ranking_widget.dart';
import 'package:flutter_tesis_app/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference restaurant = FirebaseFirestore.instance.collection('restaurante');
  final CollectionReference hotel = FirebaseFirestore.instance.collection('hoteles');
  final CollectionReference siteTuri = FirebaseFirestore.instance.collection('lugaresTuristicos');

  String userName = "User";

  int _selectIndex = 0;

  List<QueryDocumentSnapshot> list = [];
  List<QueryDocumentSnapshot> listRest = [];
  List<QueryDocumentSnapshot> listHotel = [];
  List<QueryDocumentSnapshot> listSiteTur = [];
  bool loading = true;

  @override
  void initState() {
    getCollection();
    userName = FirebaseAuth.instance.currentUser.displayName;
    super.initState();
  }

  void getCollection() async {
    await restaurant.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          listRest.add(element);
          list.add(element);
        });
      });
    }).catchError((error) => error);
    await hotel.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          listHotel.add(element);
          list.add(element);
        });
      });
    }).catchError((error) => error);
    await siteTuri.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          listSiteTur.add(element);
          list.add(element);
          loading = false;
        });
      });
    }).catchError((error) => error);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [
      HomeWidget(hotel: listHotel, restaurant: listRest, siteTur: listSiteTur,),
      RankingWidget(list: list, loading: loading,),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QARWASH",
          style: TextStyle(fontSize: 30),
        ),
        elevation: 2,
      ),
      drawer: MenuDrawer(userName: userName,),
      body: SafeArea(
        child: Center(
          child: _list.elementAt(_selectIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 40,),
            label: 'Ranking'
          ),
        ],
        currentIndex: _selectIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.yellow[700],
        onTap: (index){
          setState(() {
            _selectIndex = index;
          });
        },
      ),
    );
  }

}

class MenuDrawer extends StatelessWidget {
  MenuDrawer({
    Key key,
    this.userName,
  }) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Text(userName,
                    style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  bottom: 10,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_contact_cal, color: Colors.black, size:35,),
            title: const Text("Mi Perfil",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage())),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black, size:35,),
            title: const Text("Información",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>InfoPage())),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black, size:35,),
            title: const Text("Políticas de Privacidad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>PoliticsPage())),
          ),
          Divider(thickness: 2, color: Colors.black,),
          SizedBox(height: MediaQuery.of(context).size.height * 0.42,),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black, size:35,),
            title: const Text("Cerrar Sesión",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LandingPage()),
                (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
