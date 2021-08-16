import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_tesis_app/pages/map_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DetailPage extends StatefulWidget {
  final DocumentSnapshot doc;

  const DetailPage({@required this.doc});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool like = false;
  bool dislike = false;
  int likeNum;
  int dislikeNum;

  @override
  void initState() {
    likeNum = widget.doc['like'];
    dislikeNum = widget.doc['dislike'];
    getPref();
    super.initState();
  }

  void getPref ()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    bool _like = (pref.getBool('like') ?? false);
    bool _dislike = (pref.getBool('dislike') ?? false);
    setState(() {
      like = _like;
      dislike = _dislike;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scrollController = ScrollController();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc['nombre'],
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemCount: widget.doc['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.doc['images'][index],
                  width: media.size.width,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.doc['nombre'],
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                      icon: Icon(like ? Icons.thumb_up : Icons.thumb_up_outlined),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(likeNum.toString(),
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
                        if (value == LocationPermission.always) {
                          Position position =
                              await Geolocator.getCurrentPosition();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MapPage(
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
                      icon: Icon(dislike ? Icons.thumb_down : Icons.thumb_down_outlined),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(dislikeNum.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
              ),
              height: MediaQuery.of(context).size.height * 0.27,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                  SizedBox(height: 10,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Text(widget.doc['descripcion'] == ""
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

  void _like()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if(like){
        like = false;
        likeNum --;
        widget.doc.reference.update({
          'like': widget.doc['like'] - 1 
        });
      }else{
        like = true;
        likeNum ++;
        widget.doc.reference.update({
          'like': widget.doc['like'] + 1 
        });
        if(dislike){
          dislike = false;
          dislikeNum--;
          widget.doc.reference.update({
            'dislike': widget.doc['dislike'] - 1 
        });
        }
      }  
    });
    await pref.setBool('like', like);
    await pref.setBool('dislike', dislike);
    print(like);
  }

  void _dislike()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      if(dislike){
        dislike = false;
        dislikeNum--;
        widget.doc.reference.update({
          'dislike': widget.doc['dislike'] - 1 
        });
      }else{
        dislike = true;
        dislikeNum++;
        widget.doc.reference.update({
          'dislike': widget.doc['dislike'] + 1 
        });
        if(like){
          like = false;
          likeNum--;
          widget.doc.reference.update({
            'like': widget.doc['like'] - 1 
        });
        }
      }
    });
    await pref.setBool('like', like);
    await pref.setBool('dislike', dislike);
    print(dislike);
  }

}
