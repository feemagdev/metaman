import 'package:crypto_exchange/models/token_market_model.dart';
import 'package:crypto_exchange/services/token_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokenVisibility extends StatefulWidget {
  static const String routeID = 'token_visibility';
  const TokenVisibility({Key? key}) : super(key: key);

  @override
  State<TokenVisibility> createState() => _TokenVisibilityState();
}

class _TokenVisibilityState extends State<TokenVisibility> {
  List<TokenMarketModel> _matchingList = [];
  final TextEditingController _query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final tokenService = Provider.of<TokenService>(context);
    final userService = Provider.of<UserService>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 2.0,
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Text(
                            'Token Visibility',
                            textScaleFactor: 1.2,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: _query,
                        onChanged: (String val) {
                          if (_query.text.isEmpty || val.isEmpty) {
                            setState(() {
                              _matchingList = [];
                            });
                          } else {
                            _matchingList = [];
                            for (var tokenMarket
                                in tokenService.tokenMarketData) {
                              String name = tokenMarket.name.toLowerCase();
                              String symbol = tokenMarket.symbol.toLowerCase();
                              if (name.contains(_query.text) ||
                                  symbol.contains(_query.text)) {
                                setState(() {
                                  _matchingList.add(tokenMarket);
                                });
                              }
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Tokens',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 2.0, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _query.text.isNotEmpty || _matchingList.isNotEmpty
                      ? _searchedResult(userService)
                      : ListView.builder(
                          itemCount: tokenService.tokenMarketData.length,
                          itemBuilder: (context, index) {
                            final TokenMarketModel marketModel =
                                tokenService.tokenMarketData[index];
                            return ListTile(
                              leading: Image.network(
                                marketModel.image,
                                width: 30.0,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/logo.png',
                                    width: 30.0,
                                  );
                                },
                              ),
                              title: Text(marketModel.name),
                              subtitle: Text(marketModel.symbol),
                              trailing: CupertinoSwitch(
                                value: userService.sharedPreferences
                                    .getBool(marketModel.symbol)!,
                                onChanged: (bool val) {
                                  setState(() {
                                    userService.sharedPreferences
                                        .setBool(marketModel.symbol, val);
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            );
                          },
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchedResult(
    UserService userService,
  ) {
    return ListView.builder(
      itemCount: _matchingList.length,
      itemBuilder: (context, index) {
        final TokenMarketModel marketModel = _matchingList[index];
        return ListTile(
          leading: Image.network(
            marketModel.image,
            width: 30.0,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/logo.png',
                width: 30.0,
              );
            },
          ),
          title: Text(marketModel.name),
          subtitle: Text(marketModel.symbol),
          trailing: CupertinoSwitch(
            value: userService.sharedPreferences.getBool(marketModel.symbol)!,
            onChanged: (bool val) {
              setState(
                () {
                  userService.sharedPreferences
                      .setBool(marketModel.symbol, val);
                },
              );
            },
            activeColor: Colors.blue,
          ),
        );
      },
    );
  }
}
