import 'dart:math';

import 'package:crypto_exchange/models/token_market_model.dart';
import 'package:crypto_exchange/models/tokens.dart';
import 'package:crypto_exchange/services/token_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final userService = Provider.of<UserService>(context);
    final tokenService = Provider.of<TokenService>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getName(userService),
          const SizedBox(
            height: 10.0,
          ),
          _getBalanceDetails(tokenService, userService, size, context),
          const SizedBox(
            height: 10.0,
          ),
          tokenService.tokenLoading ? const Text('') : const Text('Tokens'),
          _getTokens(tokenService,
              userService.sharedPreferences.getString('currency_symbol'))
        ],
      ),
    );
  }

  Widget _getName(UserService userService) {
    String? name = userService.sharedPreferences.getString('user_name');
    if (name == null) {
      return const Text('');
    }
    return Text(
      'Hi $name!',
      textScaleFactor: 1.5,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _balanceUI(Size size, double result, double priceChangeIn24h,
      String currency, String currencyCode) {
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Portfolio',
              textScaleFactor: 1.5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Total $currency Value',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.3,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              '$currencyCode ${NumberFormat.decimalPattern().format(result)}',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.5,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'change in 24h',
                  textScaleFactor: 1.3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Text(
                  '|',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          priceChangeIn24h.toStringAsFixed(1),
                          textScaleFactor: 1.3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: priceChangeIn24h.isNegative
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        Text(
                          '%',
                          textScaleFactor: 1.3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: priceChangeIn24h.isNegative
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        priceChangeIn24h.isNegative
                            ? const Icon(
                                Icons.arrow_downward_outlined,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.green,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getBalanceDetails(
      TokenService tokenService, UserService userService, Size size, context) {
    String? bscAddress = userService.sharedPreferences.getString('bsc_address');

    if (tokenService.tokenLoading) {
      tokenService.getTokens(bscAddress!);
      return const Text('');
    } else {
      return _balanceUI(
          size,
          tokenService.totaCurrenctlValue,
          tokenService.change24hPercent,
          userService.sharedPreferences.getString('currency')!,
          userService.sharedPreferences.getString('currency_symbol')!);
    }
  }

  // Widget _createChart(
  //   List<HighLow> highLowData,
  //   BscService bsc,
  // ) {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           TextButton(
  //             onPressed: () {
  //               bsc.getChartData('d');
  //             },
  //             child: const Text('DAY'),
  //             style: TextButton.styleFrom(),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               bsc.getChartData('w');
  //             },
  //             child: const Text('WEEK'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               bsc.getChartData('m');
  //             },
  //             child: const Text('MONTH'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               bsc.getChartData('y');
  //             },
  //             child: const Text('YEAR'),
  //           ),
  //         ],
  //       ),
  //       SfCartesianChart(
  //         tooltipBehavior: TooltipBehavior(enable: true),
  //         primaryXAxis:
  //             CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
  //         series: <ChartSeries>[
  //           LineSeries<HighLow, String>(
  //             dataSource: highLowData,
  //             color: Colors.blue,
  //             xValueMapper: (HighLow time, _) => time.time,
  //             yValueMapper: (HighLow price, _) => price.price,
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _getTokens(TokenService tokenService, String? currencyCode) {
    if (tokenService.tokenLoading) {
      return const LinearProgressIndicator();
    } else {
      return Expanded(
        child: ListView.separated(
          itemCount: tokenService.tokens.length,
          itemBuilder: (context, index) {
            Token token = tokenService.tokens[index];
            return InkWell(
              onTap: () {
                tokenService.getTokenChangePercent(
                    '1D', tokenService.tokenMarketData[index]);
                _showModal(context, token, tokenService.tokenMarketData[index]);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // right part
                    Row(
                      children: [
                        Image.network(
                          token.logoUrl,
                          width: 30.0,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/logo.png',
                              width: 30.0,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              token.contractName,
                              textScaleFactor: 1.2,
                            ),
                            Text(
                              token.contractTickerSymbol,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        )
                      ],
                    ),
                    //left part
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currencyCode ${(tokenService.tokenMarketData[index].currentPrice * (double.parse(token.balance) / pow(10, token.contractDecimals))).toStringAsFixed(2)}',
                        ),
                        Text(
                          NumberFormat.compact(locale: 'en_US').format(
                              (double.parse(token.balance) /
                                  pow(10, token.contractDecimals))),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
            // ListTile(
            //   leading: Image.network(
            //     token.logoUrl,
            //     width: 30.0,
            //     errorBuilder: (context, error, stackTrace) {
            //       return Image.asset(
            //         'assets/images/logo.png',
            //         width: 10.0,
            //       );
            //     },
            //   ),
            //   title: Text(token.contractName),
            //   subtitle: Text(token.contractTickerSymbol),
            //   trailing: Column(
            //     children: [
            //       Text(token.quote.toStringAsFixed(2)),
            //       const Text('data')
            //     ],
            //   ),
            // );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.black38,
            );
          },
        ),
      );
    }
  }

  void _showModal(
      BuildContext context, Token token, TokenMarketModel tokenMarketData) {
    final userService = Provider.of<UserService>(context, listen: false);
    final tokenService = Provider.of<TokenService>(context, listen: false);
    String currecny = userService.sharedPreferences.getString('currency')!;
    String currecnySymbol =
        userService.sharedPreferences.getString('currency_symbol')!;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // coin icon name and close button icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // right part
                    Row(
                      children: [
                        Image.network(
                          token.logoUrl,
                          width: 30.0,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/logo.png',
                              width: 30.0,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              token.contractName,
                              textScaleFactor: 1.2,
                            ),
                            Text(
                              token.contractTickerSymbol,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        )
                      ],
                    ),
                    // CLOSE BUTTON
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('price'),
                    Text(
                        '$currecnySymbol${token.quoteRate.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(
                  color: Colors.black38,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total ${token.contractTickerSymbol}'),
                    Text((double.parse(token.balance) /
                            pow(10, token.contractDecimals))
                        .toStringAsFixed(2)),
                  ],
                ),
                const Divider(
                  color: Colors.black38,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total $currecny value'),
                    Text(
                        '$currecnySymbol${(tokenMarketData.currentPrice * (double.parse(token.balance) / pow(10, token.contractDecimals))).toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(
                  color: Colors.black38,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Market Cap'),
                    Text(
                      '$currecnySymbol ${NumberFormat.decimalPattern().format(tokenMarketData.marketCap)}',
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black38,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('% Change'),
                        TextButton(
                          onPressed: () {
                            tokenService.getTokenChangePercent(
                                '1D', tokenMarketData);
                            setState(() {});
                          },
                          child: const Text('1D'),
                        ),
                        TextButton(
                          onPressed: () {
                            tokenService.getTokenChangePercent(
                                '1W', tokenMarketData);
                            setState(() {});
                          },
                          child: const Text('1W'),
                        ),
                        TextButton(
                          onPressed: () {
                            tokenService.getTokenChangePercent(
                                '1M', tokenMarketData);
                            setState(() {});
                          },
                          child: const Text('1M'),
                        ),
                      ],
                    ),
                    Text(tokenService.selectedPerecet.toStringAsFixed(2)),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
