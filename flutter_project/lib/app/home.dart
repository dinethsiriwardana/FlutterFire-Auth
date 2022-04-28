import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'servises/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //find logged user's data from firebase
  final user = FirebaseAuth.instance.currentUser;
  // assign user email ,user id from user
  String? get useremail => user!.email;
  String? get userid => user!.uid;

  _signout() {
    //connect Class Auth from app/servises/auth.dart using provider create in main.dart
    final auth = Provider.of<AuthBase>(context, listen: false);
    auth.signOut(); //call for signout
  }

  _delete() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    auth.deleteacc(); //call for signout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              useremail!,
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              userid!,
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50.0,
              width: 320.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ))),
                onPressed: _signout,
                child: Text(
                  'Signout',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40.0,
              width: 280.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ))),
                onPressed: _delete,
                child: Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
