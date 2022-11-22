import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late String _userId;
  late DateTime _expiryDate;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDSMKP7miRB8sk30BHb5uEhqPSrpusYgbU');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      print(json.decode(response.body));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDSMKP7miRB8sk30BHb5uEhqPSrpusYgbU');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      print(json.decode(response.body));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (error) {
      throw error;
    }
  }
}
