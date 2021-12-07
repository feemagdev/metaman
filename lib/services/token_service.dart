import 'dart:convert';

import 'package:crypto_exchange/apis/api.dart';
import 'package:crypto_exchange/models/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TokenService with ChangeNotifier {
  List<Token> tokens = [];
  double totaCurrenctlValue = 0.0;
  double total24hAgoValue = 0.0;
  bool tokenLoading = true;
  double change24hPercent = 0.0;
  getTokens(String address) async {
    final apiUrl =
        'https://stg-api.unmarshal.io/v1/bsc/address/$address/assets?auth_key=${ApiKeys.tokenApi}';
    final response = await http.get(Uri.parse(apiUrl));
    List<dynamic> data = jsonDecode(response.body);
    tokens = [];
    totaCurrenctlValue = 0.0;
    change24hPercent = 0.0;
    double totalCurrentRate = 0.0;
    total24hAgoValue = 0.0;
    tokenLoading = false;
    for (var element in data) {
      if (element['quote'].toDouble() <= 0.0) {
        continue;
      }
      double singleEelement24Val = double.parse(element['quote_rate_24h']);
      if (singleEelement24Val.isNegative) {
        singleEelement24Val = singleEelement24Val * -1;
      } else {
        singleEelement24Val = singleEelement24Val * -1;
      }

      totaCurrenctlValue += element['quote'].toDouble();
      totalCurrentRate += element['quote_rate'].toDouble();
      total24hAgoValue +=
          element['quote_rate'].toDouble() + singleEelement24Val;

      tokens.add(Token.fromMap(element));
    }
    double val = (totalCurrentRate - total24hAgoValue) / total24hAgoValue;
    change24hPercent = val * 100;

    notifyListeners();
  }
}
