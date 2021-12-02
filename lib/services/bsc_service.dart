import 'dart:convert';

import 'package:crypto_exchange/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BscService with ChangeNotifier {
  bool loading = false;
  bool wrong = false;
  String errorMessage = '';
  getUserBalance(String text) async {
    loading = true;
    notifyListeners();
    final apiUrl =
        'https://api.bscscan.com/api?module=account&action=balance&address=$text&apikey=${ApiKeys.bscApiKey}';
    final response = await http.get(Uri.parse(apiUrl));
    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    String status = data['status'];
    String message = data['message'];
    String result = data['result'];
    if (status == '0') {
      wrong = true;
      errorMessage = message;
      loading = false;
      notifyListeners();
    }
  }
}
