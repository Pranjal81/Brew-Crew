import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/textfieldDeco.dart';
import 'package:brew_crew/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn({this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = "";
  String password = "";
  String error="";
  bool loading =false;
  final _formkey= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading? Loading():GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus= FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
          child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: Text("Sign In Brew Crew"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                widget.toggle();
              },
              label: Text('Register'),
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
                  decoration: TextFieldDeco.copyWith(hintText:"Email"),
                  validator: (val)=> val.isEmpty?"Enter an email":null,
                  onChanged: (val) {
                    setState(()=>email=val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: TextFieldDeco.copyWith(hintText:"Password"),
                  validator: (val)=>val.length<=6?"Password lenght must be greater than 6":null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(()=>password=val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    if(_formkey.currentState.validate()){
                      setState(() {
                        loading=true;
                      });
                      dynamic result = _auth.signInWithEmailAndPassword(email, password);
                      if(result ==null){
                        setState(() {
                          error="Please supply a valid email";
                          loading=false;
                        });
                      }
                    }
                  },
                  color: Colors.pink,
                  child: Text('Sign in',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 20,),
                Text(error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
