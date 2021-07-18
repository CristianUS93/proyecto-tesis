import 'package:flutter/material.dart';

class TiendasListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiendas"),
      ),
      body: SafeArea(
        child: Center(
          child: Text("TIENDAS"),
        ),
      ),
    );
  }
}
