import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("INFORMACIÓN",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            const Text("Desarrolladores",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30,),
            /*
            DeveloperInfo(
              developerName: "CRISTIAN UCAÑÁN",
              city: "Trujillo - Perú",
              imageName: "assets/foto1.jpg",
              size: _size,
              facebookUrl: "https://www.facebook.com/cristian.ucanansanchez",
              linkedinUrl: "https://www.linkedin.com/in/cristian-uca%C3%B1%C3%A1n-832894108",
              twitterUrl: "https://twitter.com/cristian_ucanan?s=08",
            ),
            SizedBox(height: 50),
            */
            DeveloperInfo(
              developerName: "JENNER CONCO",
              city: "Huaráz - Perú",
              imageName: "assets/foto2.jpg",
              size: _size,
              facebookUrl: "https://www.facebook.com/jenner.condex",
              linkedinUrl: "https://www.linkedin.com/in/jenner-conco-dextre-71420b186",
              twitterUrl: "https://twitter.com/JennerConDex?s=09",
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
    @required this.facebookUrl,
    @required this.linkedinUrl,
    @required this.twitterUrl,
  }) : super(key: key);
  final String developerName;
  final String city;
  final String imagePath;
  final String imageName;
  final Size size;
  final String facebookUrl;
  final String twitterUrl;
  final String linkedinUrl;

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
                  SocialLogo(
                    imagePath: "assets/facebook.png",
                    url: facebookUrl,
                  ),
                  SocialLogo(
                    imagePath: "assets/linkedin.png",
                    url: linkedinUrl,
                  ),
                  SocialLogo(
                    imagePath: "assets/twitter.png",
                    url: twitterUrl,
                  ),
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
    @required this.url
  }) : super(key: key);
  final String imagePath;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> launch(url),
      child: Container(
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
      ),
    );
  }
}