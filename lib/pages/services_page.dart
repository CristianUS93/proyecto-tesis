import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/utils/favorites_widget.dart';
import 'package:flutter_tesis_app/utils/service_list_widget.dart';

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
  List<QueryDocumentSnapshot> _list = [];
  int _selectIndex = 0;
  List<dynamic> _favList = [];

  void getList()async{
    CollectionReference _ref = FirebaseFirestore.instance.collection(widget.servicesName);
    CollectionReference _favorites = FirebaseFirestore.instance.collection('users');
    final String _userToken = FirebaseAuth.instance.currentUser.uid;
    
    await _favorites.get().then((value){
      value.docs.forEach((element) {
        if(element['token'] == _userToken){
          setState(()=> _favList = element['favoritos']);
        }
      });
    });
    List<QueryDocumentSnapshot> _global = [];
    await _ref.get().then((value){
      value.docs.forEach((element) {
        setState(()=> _global.add(element));
      });
    });
    _global.forEach((element) {
      if(_favList.contains(element.id)){
        _list.add(element);
      }
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection(widget.servicesName).snapshots();

    List<Widget> _listWidget = [
      SelectListWidget(serviceName: widget.servicesName, stream: _stream,),
      FavoritosListWidget(list: _list,)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _listWidget[_selectIndex],
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

