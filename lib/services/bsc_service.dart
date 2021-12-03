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
  double currentBnbPrice = 0.0;
  double high24h = 0.0;
  double low24h = 0.0;
  double priceChangeIn24h = 0.0;
  getUserBalance(String text) async {
    final apiUrl =
        'https://api.bscscan.com/api?module=account&action=balance&address=$text&apikey=${ApiKeys.bscApiKey}';
    final response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> data = jsonDecode(response.body);
    statusCode = data['status'];
    message = data['message'];
    result = data['result'];
    loading = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('status', statusCode);
    sharedPreferences.setString('message', message);
    sharedPreferences.setString('result', result);
    const bnbDetailsUrl =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=binancecoin&order=market_cap_desc&per_page=100&page=1&sparkline=false';
    final responseBnbDetails = await http.get(Uri.parse(bnbDetailsUrl));
    final dataBnb = jsonDecode(responseBnbDetails.body);
    currentBnbPrice = dataBnb[0]['current_price'];
    high24h = dataBnb[0]['high_24h'];
    low24h = dataBnb[0]['low_24h'];
    priceChangeIn24h = dataBnb[0]['price_change_percentage_24h'];

    notifyListeners();
  }
}
