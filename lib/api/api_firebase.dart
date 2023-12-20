// ignore_for_file: avoid_print, body_might_complete_normally_catch_error

import 'dart:io';
import 'package:customer_taxi_booking_app/global/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // Sign up user
  Future<void> uploadImageToStorage(
    imageFile,
    urlOfUploadedImage,
    emailController,
    passwordController,
    nameController,
    phoneController,
  ) async {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIDName);

    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    registerNewDriver(emailController, passwordController, nameController,
        phoneController, urlOfUploadedImage);
  }

  registerNewDriver(
    emailController,
    passwordController,
    nameController,
    phoneController,
    urlOfUploadedImage,
  ) async {
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((e) {
      print(e.toString());
    }))
        .user;
    FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;
    String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
      "token": deviceRecognitionToken,
      "photo": urlOfUploadedImage
    };
    usersRef.set(userDataMap);
  }

  // sign in user
  signInUser(emailController, passwordController) async {
    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((errorMsg) {
      print(errorMsg.toString());
    }))
        .user;

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase.uid);
      await usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            userPhone = (snap.snapshot.value as Map)["phone"];
          } else {
            FirebaseAuth.instance.signOut();
          }
        } else {
          FirebaseAuth.instance.signOut();
        }
      });
    }
  }
}
