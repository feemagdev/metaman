import 'dart:convert';

import 'package:crypto_exchange/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BscService with ChangeNotifier {
  bool loading = true;
  String message = '';
  String result = '';
  String errorMessage = '';
  String statusCode = '';
  getUserBalance(String text) async {
    final apiUrl =
        'https://api.bscscan.com/api?module=account&action=balance&address=$text&apikey=${ApiKeys.bscApiKey}';
    final response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> data = jsonDecode(response.body);
    statusCode = data['status'];
    message = data['message'];
    result = data['result'];
    print(data);
    loading = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('status', statusCode);
    sharedPreferences.setString('message', message);
    sharedPreferences.setString('result', result);
    notifyListeners();
  }
}
