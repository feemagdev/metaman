import 'dart:math';

import 'package:crypto_exchange/services/bsc_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bsc = Provider.of<BscService>(context);
    final userService = Provider.of<UserService>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getName(userService),
          const SizedBox(
            height: 10.0,
          ),
          _getBalanceDetails(bsc, userService, size, context),
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

  Widget _balanceUI(Size size, double result, double priceChangeIn24h) {
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
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
            const Text(
              'Total USD Value',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.3,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              result.toStringAsFixed(3),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.3,
              style: const TextStyle(
                color: Colors.white,
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
                        priceChangeIn24h.isNegative
                            ? const Icon(
                                Icons.arrow_downward_outlined,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.green,
                              ),
                        Text(
                          priceChangeIn24h.abs().toStringAsFixed(1),
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
      BscService bsc, UserService userService, Size size, context) {
    String? bscAddress = userService.sharedPreferences.getString('bsc_address');
    if (bsc.loading) {
      bsc.getUserBalance(bscAddress!);
      return const CircularProgressIndicator();
    } else {
      if (bsc.statusCode == '0') {
        return Center(
          child: Text(bsc.message),
        );
      } else if (bsc.message.contains('Invalid API Key')) {
        return const Center(
          child: Text('Internal Error'),
        );
      }
      double result = double.parse(bsc.result);
      result = _conversion(result, bsc.currentBnbPrice);

      return _balanceUI(
        size,
        result,
        bsc.priceChangeIn24h,
      );
    }
  }

  double _conversion(result, double currentBnbPrice) {
    double rs = result / pow(10, 18);
    return rs * currentBnbPrice;
  }
}
