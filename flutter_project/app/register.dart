import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../servises/auth.dart';
import '../signin/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Column(
                  children: [
                    EmailInput(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    PasswordInput(),
                    const SizedBox(
                      height: 50.0,
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text("login"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) {
                              return UserRegister();
                            },
                          ));
                        },
                        child: Text(
                          "No account ? Register",
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox PasswordInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _passwordController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 0, 58),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Password',
          labelText: 'Enter your Password',
          // errorText: "widget.invalidEmailErrorText",
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        autocorrect: false,
        obscureText: true,
        onChanged: (email) => _updateState(),
      ),
    );
  }

  SizedBox EmailInput() {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 0, 58),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 216, 122, 0),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Enter your Email',
          labelText: 'Email',
          hintStyle: TextStyle(
            fontSize: 15,
          ),
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
        onChanged: (password) => _updateState(),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
