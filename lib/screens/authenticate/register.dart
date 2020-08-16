import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/textfieldDeco.dart';
import 'package:brew_crew/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggle;
  Register({this.toggle});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String email = "";
  String password = "";
  String error = "";
  final _formkey = GlobalKey<FormState>();
  bool loading =false;

  @override
  Widget build(BuildContext context) {
    return loading?Loading():GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: Text("Sign Up Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                widget.toggle();
              },
              label: Text('Sign in'),
              icon: Icon(Icons.person),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 20,
          ),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: TextFieldDeco.copyWith(hintText: "Email"),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: TextFieldDeco.copyWith(hintText: "Password"),
                  validator: (val) => val.length <= 6
                      ? "Password lenght must be greater than 6"
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      setState(() {
                        return loading=true;
                      });
                      dynamic result = await _auth.regiterWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = "Please supply a valid email";
                          loading = false;
                        });
                      }
                    }
                  },
                  color: Colors.pink,
                  child: Text('Register',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
