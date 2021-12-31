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
  bool metaManInfoLoading = true;
  MetaManInfo? metaManInfo;

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

    List<TokensID> tokenID = await getTokensID();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String currency = sharedPreferences.getString('currency')!;
    tokenMarketData = [];

    await Future.forEach(tokenID, (TokensID element) async {
      String id = element.id;
      final getTokenDetailsIdUrl =
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$currency&ids=$id&order=id_asc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,30d';
      final tokenDetails = await http.get(Uri.parse(getTokenDetailsIdUrl));
      List<dynamic> tokenDetailsList = jsonDecode(tokenDetails.body);
      if (tokenDetailsList.isNotEmpty) {
        TokenMarketModel marketModel = TokenMarketModel.from(
            tokenDetailsList.first, element.balance, element.decimal);
        if (marketModel.name != 'X') {
          if (sharedPreferences.containsKey(marketModel.symbol)) {
            if (sharedPreferences.getBool(marketModel.symbol)!) {
              totaCurrenctlValue += double.parse(element.balance) /
                  pow(10, element.decimal) *
                  marketModel.currentPrice;
            }
          } else {
            sharedPreferences.setBool(marketModel.symbol, true);
            totaCurrenctlValue += double.parse(element.balance) /
                pow(10, element.decimal) *
                marketModel.currentPrice;
          }
          tokenMarketData.add(marketModel);
        }
      }
    });
    await getMetaManCoinInfo();
    notifyListeners();
  }

  Future<List<TokensID>> getTokensID() async {
    const gettingAllCoinUrl =
        'https://api.coingecko.com/api/v3/coins/list?include_platform=true';
    final response2 = await http.get(Uri.parse(gettingAllCoinUrl));
    List<dynamic> data2 = jsonDecode(response2.body);
    List<TokensID> tokenID = [];
    for (var token in tokens) {
      for (var element2 in data2) {
        Map<String, dynamic> platforms = element2['platforms'];

        if (platforms.isEmpty) {
          continue;
        }
        if (platforms.containsKey('binance-smart-chain')) {
          if (platforms['binance-smart-chain'] == token.contractAddress) {
            tokenID.add(TokensID(
                id: element2['id'],
                decimal: token.contractDecimals,
                balance: token.balance));
            continue;
          }
        }
        if (token.contractTickerSymbol.toLowerCase() == 'bnb') {
          if (platforms.containsKey('binancecoin')) {
            if (platforms['binancecoin'] == 'BNB' &&
                element2['id'] == 'binancecoin') {
              tokenID.add(TokensID(
                  id: element2['id'],
                  decimal: token.contractDecimals,
                  balance: token.balance));
              continue;
            }
          }
        }
        // if (tokenData.toLowerCase() == tokenMatch) {
        //   i++;
        //   tokenID[counter] = element2['id'];
        //   if (i > 1) {
        //     if (token.contractName == element2['name']) {
        //       tokenID[counter] = element2['id'];
        //       continue;
        //     }
        //   }
        // }
      }
      // if (i == 0) {
      //   for (var element2 in data2) {
      //     if (token.contractName == element2['name']) {
      //       tokenID[counter] = element2['id'];
      //     }
      //   }
      // }
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

  Future<void> getMetaManCoinInfo() async {
    const metaManInfoUrl =
        'https://api.nomics.com/v1/currencies/ticker?key=${ApiKeys.nomicsApi}&ids=METAMAN&convert=USD&interval=interval=1h,1d,7d,30d,365d';
    final response = await http.get(Uri.parse(metaManInfoUrl));
    List<dynamic> data = jsonDecode(response.body);
    dynamic dataList = data[0];
    dynamic chnageIn1day = dataList['1d'] ?? '';
    metaManInfo = MetaManInfo(
        price: dataList['price'],
        changeIn1h: chnageIn1day['price_change_pct'] ?? '',
        rank: dataList['rank']);
    metaManInfoLoading = false;
    notifyListeners();
  }
}

class TokensID {
  final String id;
  final int decimal;
  final String balance;

  TokensID({required this.id, required this.decimal, required this.balance});
}

class MetaManInfo {
  final String price;
  final String changeIn1h;
  final String rank;

  MetaManInfo(
      {required this.price, required this.changeIn1h, required this.rank});
}
