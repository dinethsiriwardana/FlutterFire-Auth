import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/home.dart';
import 'app/servises/auth.dart';
import 'app/welcome.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,
        listen: false); //Get Data from 'app/servises/auth.dart' using provider

    return StreamBuilder<User?>(
      //  Create stream builder
      stream: auth
          .authStateChanges(), // check authStateChanges in auth.dart for check the user is logged
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            //if no user logged
            return WelcomePage();
          }
          return HomePage();
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}
