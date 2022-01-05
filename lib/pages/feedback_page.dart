import 'package:crypto_exchange/services/token_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedBackPage extends StatelessWidget {
  const FeedBackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tokenService = Provider.of<TokenService>(context);
    final userService = Provider.of<UserService>(context);

    if (tokenService.metaManInfoLoading) {
      String currecncy = userService.sharedPreferences.getString('currency')!;
      tokenService.getMetaManCoinInfo2(currecncy);
    }
    return tokenService.metaManInfoLoading
        ? Scaffold(
            body: Center(
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
            ),
          )
        : Scaffold(
            backgroundColor: Colors.blue,
            body: Stack(
              children: [
                Positioned(
                  right: 20,
                  left: 20,
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: Container(
                    padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'METAMANCOIN',
                                  textScaleFactor: 0.9,
                                  style: _titleStyle(),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Text(
                                  'Change in 24h',
                                  textScaleFactor: 0.9,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${userService.sharedPreferences.getString('currency_symbol')}' +
                                      tokenService.metaManInfo!.price,
                                  textScaleFactor: 0.9,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                _getPerecentText(
                                    tokenService.metaManInfo!.changeIn1h)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * 0.50,
                  ),
                ),
              ],
            ),
          );
  }

  TextStyle _titleStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  Text _getPerecentText(String changeIn1h) {
    double changePerecent = double.parse(changeIn1h);

    return Text(
      changePerecent.toString() + '%',
      textScaleFactor: 0.9,
      style: TextStyle(
        color: changePerecent < 0 ? Colors.red : Colors.green,
      ),
    );
  }
}
