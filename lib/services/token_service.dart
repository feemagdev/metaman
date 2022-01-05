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
  double totaCurrenctlValue = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var selectedPerecet;
  double total24hAgoValue = 0.0;
  bool tokenLoading = true;
  double change24hPercent = 0.0;
  List<TokenMarketModel> tokenMarketData = [];
  bool metaManInfoLoading = true;
  _MetaManInfo? metaManInfo;

  getTokens(String address) async {
    try {
      totaCurrenctlValue = 0.0;
      total24hAgoValue = 0.0;
      tokenMarketData.clear();
      change24hPercent = 0.0;

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      List<Token> tokens = await _getAllAssetsOfAddress(address);

      List<_TokensID> tokenID = await getTokensID(tokens);

      if (tokenID.isEmpty) {
        tokens.clear();
        tokenMarketData.clear();
        tokenLoading = false;
        notifyListeners();
        return;
      }
      tokenID.sort((a, b) => a.id.compareTo(b.id));
      String idString = '';
      for (var element in tokenID) {
        idString += element.id + ',';
      }

      await getMetaManCoinInfo(sharedPreferences.getString('currency')!);

      await _getMarketData(tokenID, sharedPreferences, idString);

      tokenLoading = false;

      notifyListeners();
    } catch (exception) {
      tokenMarketData.clear();
      totaCurrenctlValue = 0.0;
      total24hAgoValue = 0.0;
      change24hPercent = 0.0;
      tokenLoading = false;
      notifyListeners();
    }
  }

  Future<List<Token>> _getAllAssetsOfAddress(String address) async {
    List<Token> tokens = [];
    double totalCurrentRate = 0.0;
    double tempTotal24hAgoValue = 0.0;
    double tempChange24hPercent = 0.0;
    final apiUrl =
        'https://stg-api.unmarshal.io/v1/bsc/address/$address/assets?auth_key=${ApiKeys.tokenApi}';
    final response = await http.get(Uri.parse(apiUrl));
    List<dynamic> data = jsonDecode(response.body);
    for (var element in data) {
      double singleEelement24Val = double.parse(element['quote_rate_24h']);
      if (singleEelement24Val.isNegative) {
        singleEelement24Val = singleEelement24Val * -1;
      } else {
        singleEelement24Val = singleEelement24Val * -1;
      }

      totalCurrentRate += element['quote_rate'].toDouble();
      tempTotal24hAgoValue +=
          element['quote_rate'].toDouble() + singleEelement24Val;

      tokens.add(Token.fromMap(element));
    }
    double val =
        (totalCurrentRate - tempTotal24hAgoValue) / tempTotal24hAgoValue;
    tempChange24hPercent = val * 100;

    change24hPercent = tempChange24hPercent;
    return tokens;
  }

  _getMarketData(List<_TokensID> tokenID, SharedPreferences sharedPreferences,
      String idString) async {
    double currentValue = 0.0;
    final getTokenDetailsIdUrl =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=${sharedPreferences.getString('currency')!}&ids=$idString&order=id_asc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,30d';
    final tokenDetails = await http.get(Uri.parse(getTokenDetailsIdUrl));

    List<dynamic> tokenDetailsList = jsonDecode(tokenDetails.body);
    if (tokenID.isNotEmpty) {
      tokenMarketData.clear();
      totaCurrenctlValue = 0.0;
      for (var element2 in tokenID) {
        if (element2.id == 'METAMANCOIN') {
          Map<String, dynamic> data = {
            'id': 'METAMAN',
            'symbol': 'METAMAN',
            'name': 'METAMANCOIN',
            'market_cap': metaManInfo!.marketCap,
            'price_change_percentage_24h_in_currency':
                double.parse(metaManInfo!.changeIn1h),
            'price_change_percentage_30d_in_currency':
                double.parse(metaManInfo!.changeIn30day),
            'price_change_percentage_7d_in_currency':
                double.parse(metaManInfo!.changeIn7day),
            'current_price': double.parse(metaManInfo!.price),
            'image': metaManInfo!.image,
          };
          TokenMarketModel marketModel =
              TokenMarketModel.from(data, element2.balance, element2.decimal);
          if (sharedPreferences.containsKey(marketModel.symbol)) {
            if (sharedPreferences.getBool(marketModel.symbol)!) {
              currentValue += double.parse(element2.balance) /
                  pow(10, element2.decimal) *
                  marketModel.currentPrice;
            }
          } else {
            sharedPreferences.setBool(marketModel.symbol, true);
            currentValue += double.parse(element2.balance) /
                pow(10, element2.decimal) *
                marketModel.currentPrice;
          }
          tokenMarketData.add(marketModel);
          continue;
        }
        for (var element in tokenDetailsList) {
          if (element2.id == element['id']) {
            TokenMarketModel marketModel = TokenMarketModel.from(
                element, element2.balance, element2.decimal);
            if (sharedPreferences.containsKey(marketModel.symbol)) {
              if (sharedPreferences.getBool(marketModel.symbol)!) {
                currentValue += double.parse(element2.balance) /
                    pow(10, element2.decimal) *
                    marketModel.currentPrice;
              }
            } else {
              sharedPreferences.setBool(marketModel.symbol, true);
              currentValue += double.parse(element2.balance) /
                  pow(10, element2.decimal) *
                  marketModel.currentPrice;
            }
            tokenMarketData.add(marketModel);
            totaCurrenctlValue = currentValue;
            continue;
          }
        }
      }
    }
  }

  Future<List<_TokensID>> getTokensID(List<Token> tokens) async {
    String metaManAddress = '0x7e96790c9e36d4105e98ed4411e0a6c664ebd480';
    const gettingAllCoinUrl =
        'https://api.coingecko.com/api/v3/coins/list?include_platform=true';
    final response2 = await http.get(Uri.parse(gettingAllCoinUrl));
    List<dynamic> data2 = jsonDecode(response2.body);
    List<_TokensID> tokenID = [];
    for (var token in tokens) {
      if (token.contractAddress == metaManAddress) {
        tokenID.add(_TokensID(
            id: 'METAMANCOIN',
            decimal: token.contractDecimals,
            balance: token.balance));
        continue;
      }
      for (var element2 in data2) {
        Map<String, dynamic> platforms = element2['platforms'];

        if (platforms.isEmpty) {
          continue;
        }
        if (platforms.containsKey('binance-smart-chain')) {
          if (platforms['binance-smart-chain'] == token.contractAddress) {
            tokenID.add(_TokensID(
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
              tokenID.add(_TokensID(
                  id: element2['id'],
                  decimal: token.contractDecimals,
                  balance: token.balance));
              continue;
            }
          }
        }
      }
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

  Future<void> getMetaManCoinInfo(String currency) async {
    await Future.delayed(const Duration(seconds: 1));
    final metaManInfoUrl =
        'https://api.nomics.com/v1/currencies/ticker?key=${ApiKeys.nomicsApi}&ids=METAMAN&convert=$currency&interval=interval=1h,1d,7d,30d,365d';
    final response = await http.get(Uri.parse(metaManInfoUrl));
    List<dynamic> data = jsonDecode(response.body);
    dynamic dataList = data[0];
    dynamic chnageIn1day = dataList['1d'] ?? '';
    dynamic changeIn7day = dataList['7d'] ?? '';
    dynamic changeIn30day = dataList['30d'] ?? '';
    dynamic marketCap = dataList['market_cap'] ?? 0.0;
    dynamic image = dataList['logo_url'];
    metaManInfo = _MetaManInfo(
        price: dataList['price'],
        marketCap: marketCap,
        image: image,
        changeIn1h: chnageIn1day['price_change_pct'] ?? '',
        changeIn7day: changeIn7day['price_change_pct'] ?? '',
        changeIn30day: changeIn30day['price_change_pct'] ?? '',
        rank: dataList['rank']);
  }

  Future<void> getMetaManCoinInfo2(String currency) async {
    await Future.delayed(const Duration(seconds: 1));
    final metaManInfoUrl =
        'https://api.nomics.com/v1/currencies/ticker?key=${ApiKeys.nomicsApi}&ids=METAMAN&convert=$currency&interval=interval=1h,1d,7d,30d,365d';
    final response = await http.get(Uri.parse(metaManInfoUrl));
    List<dynamic> data = jsonDecode(response.body);
    dynamic dataList = data[0];
    dynamic chnageIn1day = dataList['1d'] ?? '';
    dynamic changeIn7day = dataList['7d'] ?? '';
    dynamic changeIn30day = dataList['30d'] ?? '';
    dynamic marketCap = dataList['market_cap'] ?? 0.0;
    dynamic image = dataList['logo_url'];
    metaManInfo = _MetaManInfo(
        price: dataList['price'],
        marketCap: marketCap,
        image: image,
        changeIn1h: chnageIn1day['price_change_pct'] ?? '',
        changeIn7day: changeIn7day['price_change_pct'] ?? '',
        changeIn30day: changeIn30day['price_change_pct'] ?? '',
        rank: dataList['rank']);
    metaManInfoLoading = false;
    notifyListeners();
  }
}

class _TokensID {
  final String id;
  final int decimal;
  final String balance;

  _TokensID({required this.id, required this.decimal, required this.balance});
}

class _MetaManInfo {
  final String price;
  final String changeIn1h;
  final String changeIn7day;
  final String changeIn30day;
  final String rank;
  final double marketCap;
  final String image;

  _MetaManInfo(
      {required this.price,
      required this.changeIn1h,
      required this.rank,
      required this.changeIn7day,
      required this.changeIn30day,
      required this.marketCap,
      required this.image});
}
