import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'user_details.dart';

class TokenManager {
  static final _storage = FlutterSecureStorage();

  // Check if JWT token has expired
  static Future<bool> isTokenExpired() async {
    final token = await _storage.read(key: 'jwtToken');
    if (token != null) {
      return JwtDecoder.isExpired(token);
    }
    return true; // If token doesn't exist, consider it expired
  }

  // Store JWT token securely
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
    // print('Token stored successfully');
  }

  // Retrieve JWT token
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'jwtToken');
    } catch (error) {
      print('Error retrieving token: $error');
      return null;
    }
  }

  // Delete JWT token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwtToken');
  }

  // Perform logout
  static Future<void> logoutUser() async {
    await deleteToken();
    await LocalStorage.clearUserDetails(); // Call clearUserDetails upon logout
    // Additional logout logic if needed (e.g., clear user data, navigate to login screen)
  }

  // Check if JWT token is valid (exists and not expired)
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token != null) {
      return !JwtDecoder.isExpired(token);
    }
    return false; // Token does not exist or is expired
  }
}
