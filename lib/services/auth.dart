import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService{

  final FirebaseAuth _auth= FirebaseAuth.instance;

  //create user obj based on Firebase user
  User userFromFirebaseUser(FirebaseUser user){
    return user!=null? User(uid: user.uid): null;
  }

  //sign in anon
  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //Stream user
  Stream<User> get user{
    return _auth.onAuthStateChanged
      .map((FirebaseUser user)=>userFromFirebaseUser(user));
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;

      return userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future singOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future regiterWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with the UID
      await DatabaseService(uid: user.uid).update('0', "new brew user", 100); 

      return userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}