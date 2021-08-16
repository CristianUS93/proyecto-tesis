import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  static User userInfo;

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    final snackBarWrong = SnackBar(
      content: Text("Ocurrió un error al conectarse"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value){
          LoginPage.userInfo = value.user;
        })
        .catchError((error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(snackBarWrong);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/background_image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
          ),
          Positioned(
            top: 145,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: const Text("QARWASH",
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.black45),
                ),
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: const Text("QARWASH",
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            top: 210,
            right: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: const Text("Conoce nuestro Callejón de Huaylas",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Inicia Sesión con Google",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(width: 15,),
                    Image(image: AssetImage("assets/google_icon.png"),)
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  primary: Colors.white,
                ),
                onPressed: () {
                  signInWithGoogle(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
