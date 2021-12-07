import 'dart:convert';

import 'package:crypto_exchange/apis/api.dart';
import 'package:crypto_exchange/models/high_low.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BscService with ChangeNotifier {
  bool loading = true;
  String message = '';
  String result = '';
  String errorMessage = '';
  String statusCode = '';
  double currentBnbPrice = 0.0;
  double priceChangeIn24h = 0.0;
  bool chartLoading = true;
  List<HighLow> highLowData = [];
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
    String currency = sharedPreferences.getString('currency')!;
    final bnbDetailsUrl =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$currency&ids=binancecoin&order=market_cap_desc&per_page=100&page=1&sparkline=false';
    final responseBnbDetails = await http.get(Uri.parse(bnbDetailsUrl));
    final dataBnb = jsonDecode(responseBnbDetails.body);

    currentBnbPrice = dataBnb[0]['current_price'].toDouble();
    priceChangeIn24h = dataBnb[0]['price_change_percentage_24h'];

    notifyListeners();
  }

  getChartData(String option) async {
    DateTime currentDateTime = DateTime.now();
    DateTime endTime = DateTime.now();
    switch (option) {
      case 'd':
        endTime = currentDateTime.subtract(
          const Duration(days: 1),
        );
        break;
      case 'w':
        endTime = currentDateTime.subtract(
          const Duration(days: 7),
        );
        break;
      case 'm':
        endTime = currentDateTime.subtract(
          const Duration(days: 30),
        );
        break;
      case 'y':
        endTime = currentDateTime.subtract(
          const Duration(days: 365),
        );
        break;
    }
    int unixStartTime = currentDateTime.millisecondsSinceEpoch ~/ 1000;
    int unixEndTime = endTime.millisecondsSinceEpoch ~/ 1000;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currency = sharedPreferences.getString('currency')!;
    final chartApiUrl =
        'https://api.coingecko.com/api/v3/coins/binancecoin/market_chart/range?vs_currency=$currency&from=$unixEndTime&to=$unixStartTime';
    final chartApiResponse = await http.get(Uri.parse(chartApiUrl));
    Map<String, dynamic> chartData = jsonDecode(chartApiResponse.body);
    var pricesAndTimeList = chartData['prices'] as List;
    highLowData = [];
    for (var element in pricesAndTimeList) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(element[0]);

      String time = '';
      if (option == 'd') {
        time = DateFormat("h:mma").format(dateTime);
      } else {
        time = DateFormat.yMMMMd('en_US').format(dateTime);
      }

      highLowData.add(
        HighLow(price: element[1], time: time),
      );
    }
    chartLoading = false;
    notifyListeners();
  }
}
