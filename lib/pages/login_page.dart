import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final snackBarInit = SnackBar(
      content: Text("Inicio de sesión exitoso!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    );
    final snackBarWrong = SnackBar(
      content: Text("Su e-mail o contraseña no son correctos"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(snackBarInit);
    }).catchError((error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(snackBarWrong);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Inicia sesión con tu cuenta Google"),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Seleccionar cuenta"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () {
                signInWithGoogle(context);
              },
            )
          ],
        ),
      )),
    );
  }
}
