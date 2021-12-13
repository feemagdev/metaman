import 'dart:math';

import 'package:crypto_exchange/models/token_market_model.dart';
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

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
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
            tokenService.tokenLoading
                ? const Text('')
                : const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Tokens',
                    ),
                  ),
            const SizedBox(
              height: 10.0,
            ),
            _getTokens(
                tokenService,
                userService.sharedPreferences.getString('currency_symbol'),
                userService)
          ],
        ),
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
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Portfolio',
              textScaleFactor: 1.1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Total $currency Value',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.2,
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
              textScaleFactor: 1.3,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'change in 24h',
                  textScaleFactor: 0.9,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Text(
                  '|',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          priceChangeIn24h.toStringAsFixed(1),
                          textScaleFactor: 0.9,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: priceChangeIn24h.isNegative
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        Text(
                          '%',
                          textScaleFactor: 0.9,
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
                                size: 10.0,
                              )
                            : const Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.green,
                                size: 10.0,
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

  Widget _getTokens(TokenService tokenService, String? currencyCode,
      UserService userService) {
    if (tokenService.tokenLoading) {
      return Center(
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: tokenService.tokenMarketData.length,
          itemBuilder: (context, index) {
            TokenMarketModel marketModel = tokenService.tokenMarketData[index];
            double totalValue =
                (tokenService.tokenMarketData[index].currentPrice *
                    (double.parse(marketModel.balance) /
                        pow(10, marketModel.contractDecimals)));
            if (!userService.sharedPreferences.getBool(marketModel.symbol)!) {
              return const SizedBox();
            }
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    tokenService.getTokenChangePercent('1D', marketModel);
                    _showModal(context, marketModel);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // right part
                        Row(
                          children: [
                            Image.network(
                              marketModel.image,
                              width: 35.0,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/logo.png',
                                  width: 35.0,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    marketModel.name,
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    marketModel.symbol,
                                    style: TextStyle(color: Colors.grey[500]),
                                    textScaleFactor: 0.9,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        //left part
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$currencyCode ${NumberFormat.decimalPattern().format(totalValue)}',
                              textScaleFactor: 0.9,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              NumberFormat.compact(locale: 'en_US').format(
                                (double.parse(marketModel.balance) /
                                    pow(10, marketModel.contractDecimals)),
                              ),
                              style: TextStyle(color: Colors.grey[500]),
                              textScaleFactor: 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.2,
                ),
              ],
            );
          },
        ),
      );
    }
  }

  void _showModal(BuildContext context, TokenMarketModel tokenMarketData) {
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
                          tokenMarketData.image,
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
                              tokenMarketData.name,
                              textScaleFactor: 1.2,
                            ),
                            Text(
                              tokenMarketData.symbol,
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
                            size: 17.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('price'),
                      Text('$currecnySymbol${tokenMarketData.currentPrice}'),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total ${tokenMarketData.symbol}'),
                      Text((double.parse(tokenMarketData.balance) /
                              pow(10, tokenMarketData.contractDecimals))
                          .toStringAsFixed(2)),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total $currecny value'),
                      Text(
                          '$currecnySymbol${(tokenMarketData.currentPrice * (double.parse(tokenMarketData.balance) / pow(10, tokenMarketData.contractDecimals))).toStringAsFixed(2)}'),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Market Cap'),
                      Text(
                        '$currecnySymbol ${NumberFormat.decimalPattern().format(tokenMarketData.marketCap)}',
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  thickness: 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('% Change'),
                          const SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 40.0,
                            child: TextButton(
                              onPressed: () {
                                tokenService.getTokenChangePercent(
                                    '1D', tokenMarketData);
                                setState(() {});
                              },
                              child: const Text('1D'),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 40.0,
                            child: TextButton(
                              onPressed: () {
                                tokenService.getTokenChangePercent(
                                    '1W', tokenMarketData);
                                setState(() {});
                              },
                              child: const Text('1W'),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 40.0,
                            child: TextButton(
                              onPressed: () {
                                tokenService.getTokenChangePercent(
                                    '1M', tokenMarketData);
                                setState(() {});
                              },
                              child: const Text('1M'),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200),
                            ),
                          ),
                        ],
                      ),
                      Text(tokenService.selectedPerecet.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
