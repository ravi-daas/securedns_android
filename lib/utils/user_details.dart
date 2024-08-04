import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUserDetails(String uid, String email,
      String firstName, String lastName, String displayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('7- userDeatils.dart - inside saveuserdetails');
    print(uid);
    print(email);
    print(firstName);
    print(lastName);
    print(displayName);
    print('13- userDeatils.dart - inside saveuserdetails');
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('displayName', displayName);
    
  }

  static Future<Map<String, String?>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? email = prefs.getString('email');
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');
    String? displayName = prefs.getString('displayName');
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName
    };
  }

  static Future<void> clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('displayName');
  }
}
