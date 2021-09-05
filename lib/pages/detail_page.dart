import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

import 'package:flutter_tesis_app/pages/map_page.dart';


class DetailPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final int index;
  final String nameServices;
  const DetailPage({@required this.doc, this.index, this.nameServices});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool favorite = false;

  bool like = false;
  bool dislike = false;
  int likeNum;
  int dislikeNum;

  List<Widget> listCircles = [];
  List<dynamic> listImage = [];
  int indexImage = 0;

  
  final String _userToken = FirebaseAuth.instance.currentUser.uid;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  QueryDocumentSnapshot _document;
  List<dynamic> _favoritosUser = [];
  List<dynamic> _likeUser = [];
  List<dynamic> _dislikeUser = [];

  void getUserPreferences ()async {
    await _users.where('token', isEqualTo: _userToken).get().then((value){
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          if(element['token'] == _userToken){
            setState(()=> _document = element);
            setState(()=> _favoritosUser = element['favoritos']);
            setState(()=> _likeUser = element['likes']);
            setState(()=> _dislikeUser = element['dislikes']);
            if(_favoritosUser.contains(widget.doc.id)){
              setState(() => favorite = true);
            }
            if(_likeUser.contains(widget.doc.id)){
              setState(() => like = true);
            }
            if(_dislikeUser.contains(widget.doc.id)){
              setState(() => dislike = true);
            }
          }
        });
      }
    });
  }



  @override
  void initState() {
    likeNum = widget.doc['like'];
    dislikeNum = widget.doc['dislike'];
    listImage = widget.doc['images'];
    getUserPreferences();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doc['nombre'],
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: media.height * 0.3,
            child: Stack(
              children: [
                PageView.builder(
                itemCount: listImage.length,
                onPageChanged: (index){
                  setState(() {
                    indexImage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[400],
                    child: listImage[index] == "" 
                    ? const Center(child: Text("Imagen no encontrada"))
                    : Image.network(
                      listImage[index],
                      width: media.width,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          setState(()=> favorite = !favorite);
                          if(favorite){
                            setState(()=> _favoritosUser.add(widget.doc.id));
                            _users.doc(_document.id).update({
                              'favoritos': _favoritosUser
                            }).then((value) => print("Favorito Agregado"))
                            .catchError((e)=> e);
                          }else{
                            setState(()=> _favoritosUser.remove(widget.doc.id));
                            _users.doc(_document.id).update({
                              'favoritos': _favoritosUser
                            }).then((value) => print("Favorito Borrado"))
                            .catchError((e)=> e);
                          }
                        }, 
                        child: Icon(Icons.favorite, 
                          color: favorite ? Colors.red : Colors.grey[700],
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i<listImage.length; i++)
                  CircleWidget(color: i==indexImage ? Colors.yellow : Colors.white)
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.doc['nombre'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: _like,
                      icon:
                          Icon(like ? Icons.thumb_up : Icons.thumb_up_outlined),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    likeNum.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                    onPressed: () async {
                      await Geolocator.requestPermission().then((value) async {
                        if (value == LocationPermission.always || value == LocationPermission.whileInUse) {
                          Position position =
                              await Geolocator.getCurrentPosition();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapPage(
                                        nameService: widget.doc['nombre'],
                                        initPosition: position,
                                        finalPosition: LatLng(
                                          widget.doc['latitud'],
                                          widget.doc['longitud'],
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
                    icon: Icon(Icons.location_on)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: _dislike,
                      icon: Icon(dislike
                          ? Icons.thumb_down
                          : Icons.thumb_down_outlined),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dislikeNum.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
              ),
              height: MediaQuery.of(context).size.height * 0.27,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "DESCRIPCIÓN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.doc['descripcion'] == ""
                            ? "Aún no se agreaga una descripción"
                            : widget.doc['descripcion'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _like() async {
    setState(() {
      if (like) {
        like = false;
        likeNum--;
        widget.doc.reference.update({'like': widget.doc['like'] - 1});
        likeFalse();
      } else {
        like = true;
        likeNum++;
        widget.doc.reference.update({'like': widget.doc['like'] + 1});
        likeTrue();
        if (dislike) {
          dislike = false;
          dislikeFalse();
          if(widget.doc['dislike']>0){
            dislikeNum--;
            widget.doc.reference.update({'dislike': widget.doc['dislike'] - 1});
          }
        }
      }
    });
  }

  void _dislike() async {
    setState(() {
      if (dislike) {
        dislike = false;
        dislikeNum--;
        widget.doc.reference.update({'dislike': widget.doc['dislike'] - 1});
        dislikeFalse();
      } else {
        dislike = true;
        dislikeNum++;
        widget.doc.reference.update({'dislike': widget.doc['dislike'] + 1});
        dislikeTrue();
        if (like) {
          like = false;
          likeFalse();
          if(widget.doc['like']>0){
            likeNum--;
            widget.doc.reference.update({'like': widget.doc['like'] - 1});
          }
        }
      }
    });
  }

  void likeTrue()async{
    _likeUser.add(widget.doc.id);
    print(_likeUser);
    await _users.doc(_document.id).update({
      'likes': _likeUser
    }).catchError((e)=> e);
  }
  void likeFalse()async{
    _likeUser.remove(widget.doc.id);
    await _users.doc(_document.id).update({
      'likes': _likeUser
    }).catchError((e)=> e);
  }


  void dislikeTrue()async{
    _dislikeUser.add(widget.doc.id);
    _users.doc(_document.id).update({
      'dislikes': _dislikeUser
    }).catchError((e)=> e);
  }
  void dislikeFalse()async{
    _dislikeUser.remove(widget.doc.id);
    await _users.doc(_document.id).update({
      'dislikes': _dislikeUser
    }).catchError((e)=> e);
  }

}

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key key,
    @required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
