import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _autoLogoutTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

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
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final loginData = json.encode(
          {'token': _token, 'userId': _userId, 'expiryDate': _expiryDate?.toIso8601String()});
      pref.setString('loginData', loginData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    _autoLogoutTimer = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('loginData')) {
      return false;
    }
    final loginData =
        json.decode(pref.getString('loginData')!);
        print('loginData $loginData');
    final expiryDate = DateTime.parse( loginData['expiryDate'].toString()); 

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = loginData['token'].toString();
    _userId = loginData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer?.cancel();
    }
    final timeofExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: timeofExpiry), logout);
  }
}
