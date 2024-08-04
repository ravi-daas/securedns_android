// ignore_for_file: file_names
import 'dart:convert';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../User.dart';
// import '../../models/user/UserHandlerModel.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'FirebaseAuthServiceModel.dart';
// import '../../utils/user_details.dart';
import '../../utils/token_manager.dart';

class AuthServiceModel {
  /// The function `loginWithGoogle` attempts to sign in a user using Google authentication and returns
  /// the user data if successful.
  ///
  /// Returns:
  ///   a Future object that resolves to a UserData object or null.
  // Future<UserData?> loginWithGoogle() async {
  //   final authServiceProvider = FirebaseAuthServiceModel();
  //   UserData? userModel = await authServiceProvider.signInWithGoogle();
  //   return userModel;
  // }

  /// The function `signOutUser` signs out the current user using the `FirebaseAuthServiceModel`.
  Future<void> signOutUser() async {
    await TokenManager.logoutUser();
  }

  /// The function `loginWithEmailPassword` takes an email and password as parameters, uses the
  /// `FirebaseAuthServiceModel` to sign in with the provided credentials, and returns a `UserData`
  /// object.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the user's email address.
  ///   password (String): A string representing the user's password.
  ///
  /// Returns:
  ///   a Future object that resolves to a UserData object or null.
  Future<UserData?> loginWithEmailPassword(String eMail, String pass) async {
    String url = 'http://115.113.39.74:65528/api/user/login';
    String email = eMail;
    String password = pass;
    print('45 - AuthServiceModel.dart');
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);print('53 - responseData - $responseData');
      bool success = responseData['success'];
      String jwtToken = responseData['token'];

      if (success) {
        await TokenManager.storeToken(jwtToken);
        //! is success print token
        print(jwtToken);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);print('62 - decoded Token - $decodedToken');
        String uid = decodedToken['uid'];

        // Query the users collection for a document where the uid field matches the uid decoded from the JWT token
        String detailsApiUrl = 'http://115.113.39.74:65528/api/user/userdetail';
        final response = await http.post(
          Uri.parse(detailsApiUrl),
          body: json.encode({'uid': uid}),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        print('74');
        print(response.body);
        print('76');

        if (response.statusCode == 200) {
          var userData = json.decode(response.body);
          print('80 - userData - $userData');
          // print('firstname - ${userData['firstname']}');
          // print(userData['userData']['firstname']);

          UserData? userModel = UserData(
              email: decodedToken['email'],
              uid: decodedToken['uid'],
              jwtToken: jwtToken,
              authStatusMessage: 'success',
              displayName: '${userData['userData']['firstname']} ${userData['userData']['lastname']}');
              print('88 -  userModel');
              print(userModel.toString());
          return userModel;
        } else {
          // Handle the case where no user document was found
          UserData userModel = UserData(email: null);
          return userModel;
        }
      } else {
        UserData userModel =
            UserData(email: null, authStatusMessage: 'Something went wrong!');
        return userModel;
      }
    } catch (error) {
      UserData userModel = UserData(email: null, authStatusMessage: null);
      return userModel;
    }
  }
  // Future<UserData?> loginWithEmailPassword(
  //     String email, String password) async {
  //   final authServiceProvider = FirebaseAuthServiceModel();
  //   UserData? userModel = await authServiceProvider.signInWithEmailPassword(
  //     email,
  //     password,
  //   );
  //   return userModel;
  // }

  /// The function registers a user with an email, password, name, and phone number, and stores the user
  /// details if the registration is successful.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the user's email address.
  ///   password (String): The password parameter is a string that represents the user's chosen password
  /// for their account.
  ///   name (String): The name parameter is a string that represents the user's name.
  ///   phone (String): The `phone` parameter is a string that represents the user's phone number.
  ///
  /// Returns:
  ///   a Future<UserData?>.
  Future<UserData?> registerWithEmailPassword(
      String email, String password, String name, String phone) async {
    return null;
  }

  getUserDetails() {}

  onAuthStateChanged() {}

  /// The `forgotPassword` function in Dart sends a forgot password email to the specified email address
  /// using the `FirebaseAuthServiceModel`.
  ///
  /// Args:
  ///   email (String): The email address of the user who wants to reset their password.
  // Future forgotPassword(String email) async {
  //   await FirebaseAuthServiceModel().sendForgotPasswordEmail(email);
  // }
}
