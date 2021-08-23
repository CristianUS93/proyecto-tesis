import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tesis_app/pages/info_page.dart';
import 'package:flutter_tesis_app/pages/politics_page.dart';
import 'package:flutter_tesis_app/pages/profile_page.dart';
import 'package:flutter_tesis_app/utils/home_widget.dart';
import 'package:flutter_tesis_app/utils/favorites_widget.dart';
import 'package:flutter_tesis_app/main.dart';

class HomePage extends StatefulWidget {
  static List<String> likeRest = [];
  static List<String> likeHot = [];
  static List<String> likeSite = [];

  static List<String> dislikeRest = [];
  static List<String> dislikeHot = [];
  static List<String> dislikeSite = [];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "User";
  int _selectIndex = 0;

  CollectionReference _refRest = FirebaseFirestore.instance.collection("restaurante");
  CollectionReference _refHot = FirebaseFirestore.instance.collection("hoteles");
  CollectionReference _refSite = FirebaseFirestore.instance.collection("lugaresTuristicos");

  final String _userToken = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _favorites = FirebaseFirestore.instance.collection('users');
  List<dynamic> _favList = [];
  List<QueryDocumentSnapshot> _listAllFavoritos = [];

  void getFavoritesList()async {
    await _favorites.get().then((value){
      value.docs.forEach((element) {
        if(element['token'] == _userToken){
          setState(()=> _favList = element['favoritos']);
        }
      });
    });
    addFavoriteToList();
  }

  void addFavoriteToList()async {
    List<QueryDocumentSnapshot> _global = [];
    await _refRest.get().then((value){
      value.docs.forEach((element) {
        setState(()=> _global.add(element));
      });
    });
    await _refHot.get().then((value){
      value.docs.forEach((element) {
        setState(()=> _global.add(element));
      });
    });
    await _refSite.get().then((value){
      value.docs.forEach((element) {
        setState(()=> _global.add(element));
      });
    });
    _global.forEach((element) {
      if(_favList.contains(element.id)){
        _listAllFavoritos.add(element);
      }
    });
  }

  @override
  void initState() {
    userName = FirebaseAuth.instance.currentUser.displayName;
    getFavoritesList();
    getBoolLikes();
    createUser();
    super.initState();
  }

  
  void createUser()async {
    CollectionReference _users = FirebaseFirestore.instance.collection('users');

    await _users.where('token', isEqualTo: _userToken).get()
    .then((value){
      if(value.docs.isEmpty){
        _users.add({
          'token': _userToken,
          'favoritos': [],
          'likes': [],
          'dislikes': []
        }).then((value) => print("Usuario creado"))
        .catchError((e)=>print("Error: $e"));
      }
    });
  }


  void getBoolLikes()async{
    await _refRest.get().then((value){
      value.docs.forEach((element) {
        setState((){
          HomePage.likeRest.add("F");
          HomePage.dislikeRest.add("F");
        });
      });
    });
    await _refHot.get().then((value){
      value.docs.forEach((element) {
        setState((){
          HomePage.likeHot.add("F");
          HomePage.dislikeHot.add("F");
        });
      });
    });
    await _refSite.get().then((value){
      value.docs.forEach((element) {
        setState((){
          HomePage.likeSite.add("F");
          HomePage.dislikeSite.add("F");
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [HomeWidget(), FavoritosListWidget(list: _listAllFavoritos),];

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
        unselectedIconTheme: IconThemeData(
          size: 20,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 40,),
            label: 'Favoritos',
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
