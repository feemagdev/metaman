import 'dart:convert';
import 'dart:math';

import 'package:crypto_exchange/apis/api.dart';
import 'package:crypto_exchange/models/token_market_model.dart';
import 'package:crypto_exchange/models/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenService with ChangeNotifier {
  List<Token> tokens = [];
  double totaCurrenctlValue = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var selectedPerecet;
  double total24hAgoValue = 0.0;
  bool tokenLoading = true;
  double change24hPercent = 0.0;
  List<TokenMarketModel> tokenMarketData = [];
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

      totalCurrentRate += element['quote_rate'].toDouble();
      total24hAgoValue +=
          element['quote_rate'].toDouble() + singleEelement24Val;

      tokens.add(Token.fromMap(element));
    }
    double val = (totalCurrentRate - total24hAgoValue) / total24hAgoValue;
    change24hPercent = val * 100;
    List<String> tokenID = await getTokensID();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currency = sharedPreferences.getString('currency')!;
    tokenMarketData = [];
    int i = 0;
    await Future.forEach(tokenID, (element) async {
      final getTokenDetailsIdUrl =
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$currency&ids=$element&order=id_asc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,30d';
      final tokenDetails = await http.get(Uri.parse(getTokenDetailsIdUrl));
      List<dynamic> tokenDetailsList = jsonDecode(tokenDetails.body);
      TokenMarketModel marketModel =
          TokenMarketModel.from(tokenDetailsList.first);
      if (sharedPreferences.containsKey(marketModel.symbol)) {
        if (sharedPreferences.getBool(marketModel.symbol)!) {
          totaCurrenctlValue += double.parse(tokens[i].balance) /
              pow(10, tokens[i].contractDecimals) *
              marketModel.currentPrice;
        }
      } else {
        sharedPreferences.setBool(marketModel.symbol, true);
        totaCurrenctlValue += double.parse(tokens[i].balance) /
            pow(10, tokens[i].contractDecimals) *
            marketModel.currentPrice;
      }

      tokenMarketData.add(marketModel);

      i++;
    });
    notifyListeners();
  }

  Future<List<String>> getTokensID() async {
    const gettingAllCoinUrl = 'https://api.coingecko.com/api/v3/coins/list';
    final response2 = await http.get(Uri.parse(gettingAllCoinUrl));
    List<dynamic> data2 = jsonDecode(response2.body);
    List<String> tokenID = List.filled(tokens.length, 'x');
    int counter = 0;
    for (var token in tokens) {
      int i = 0;
      String tokenData = token.contractTickerSymbol;
      for (var element2 in data2) {
        String tokenMatch = element2['symbol'];

        if (tokenData.toLowerCase() == tokenMatch) {
          i++;
          tokenID[counter] = element2['id'];
          if (i > 1) {
            if (token.contractName == element2['name']) {
              tokenID[counter] = element2['id'];
            }
          }
        }
      }
      if (i == 0) {
        for (var element2 in data2) {
          if (token.contractName == element2['name']) {
            tokenID[counter] = element2['id'];
          }
        }
      }
      counter++;
    }
    return tokenID;
  }

  void getTokenChangePercent(String s, TokenMarketModel tokenMarketModel) {
    switch (s) {
      case '1D':
        selectedPerecet = tokenMarketModel.priceChange24h;
        break;
      case '1W':
        selectedPerecet = tokenMarketModel.priceChange7d;
        break;
      case '1M':
        selectedPerecet = tokenMarketModel.priceChange30d;
        break;
    }
    notifyListeners();
  }
}
