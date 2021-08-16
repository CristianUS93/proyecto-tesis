import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("INFORMACIÓN",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60,),
            DeveloperInfo(
              developerName: "CRISTIAN UCAÑÁN",
              city: "Trujillo - Perú",
              imageName: "assets/foto1.jpg",
              size: _size,
            ),
            SizedBox(height: 50),
            DeveloperInfo(
              developerName: "JENNER CONCO",
              city: "Huaráz - Perú",
              imageName: "assets/foto2.jpg",
              size: _size,
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  const DeveloperInfo({
    Key key,
    @required this.developerName,
    @required this.city,
    this.imagePath,
    @required this.imageName,
    @required this.size,
  }) : super(key: key);
  final String developerName;
  final String city;
  final String imagePath;
  final String imageName;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: size.height * 0.18,
          width: size.width * 0.6,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(developerName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(city,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialLogo(imagePath: "assets/facebook.png",),
                  SocialLogo(imagePath: "assets/linkedin.png",),
                  SocialLogo(imagePath: "assets/twitter.png",),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: size.height * 0.15,
          width: size.height * 0.15,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(size.height * 0.08),
            image: DecorationImage(
              image: AssetImage(imageName),
            ),
          ),
        ),
      ],
    );
  }
}

class SocialLogo extends StatelessWidget {
  const SocialLogo({
    Key key,
    @required this.imagePath,
  }) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.3),
          offset: Offset(0,2),
          blurRadius: 5,
        )]
      ),
      child: Image.asset(imagePath, color: Colors.blue,),
    );
  }
}