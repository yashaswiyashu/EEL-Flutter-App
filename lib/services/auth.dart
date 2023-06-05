import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:http/http.dart' as http;

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // create user object based on firebaseUser
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null; 
  }

  //auth change user stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  //sign in with email and pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //creating a document in firestore
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateEmailAndPassword(String userId, String newEmail, String newPassword) async {
    try {
      var url = Uri.parse('https://www.ar.rscsys.in/updateUser/$userId/$newEmail/$newPassword');
      var response = await http.post(
        url,
      );
      if (response.statusCode == 200) {
        print('Email and password updated successfully.');
        return true;
      } else {
        print('Failed to update email and password. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error updating email and password: $error');
      return false;
    }
  }
}