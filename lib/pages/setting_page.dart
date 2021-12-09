import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:crypto_exchange/pages/token_visibility_page.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: true);
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const Text(
                'Options',
                textScaleFactor: 1.2,
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Settings',
                textScaleFactor: 1.1,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            userService.changeCurrency(
                                currency: currency.code,
                                currencySymbol: currency.symbol);
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // currency and icon
                          SizedBox(
                            height: 30.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.monetization_on_outlined,
                                  color: Colors.blue,
                                  size: 17.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Change Currency'),
                              ],
                            ),
                          ),
                          // currency name and forward icon
                          Row(
                            children: [
                              Text(
                                userService.sharedPreferences
                                    .getString('currency')!,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, TokenVisibility.routeID);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 30.0,
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.blue,
                                  size: 17.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Token Visibility'),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15.0,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    InkWell(
                      onTap: () {
                        _showWarningDialog(context, userService);
                      },
                      child: SizedBox(
                        height: 30.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.blue,
                              size: 17.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Clear App Data'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Help',
                textScaleFactor: 1.1,
                style: TextStyle(color: Colors.blue),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 30.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.help_outline,
                              color: Colors.blue,
                              size: 17.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Help & Support'),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 30.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.report_outlined,
                              color: Colors.blue,
                              size: 17.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('About'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'METAMAN',
                textScaleFactor: 1.2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Montserrat-ExtraBold',
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'the future of finance',
                textScaleFactor: 1.1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Montserrat-ExtraBold',
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await _launchURL(context);
                },
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 75,
                  height: 75,
                  alignment: Alignment.centerLeft,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context, UserService userService) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      btnOkText: 'DELETE',
      btnCancelText: 'CANCEL',
      title: 'Hol Up!',
      desc:
          'Clearing data will reset app. you will have to connect your wallet again to continue using the app',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        userService.sharedPreferences.clear();
        Navigator.pushReplacementNamed(context, BscAddressPage.routeID);
      },
    ).show();
  }

  Future<void> _launchURL(context) async {
    const String _url =
        'https://poocoin.app/tokens/0x7e96790c9e36d4105e98ed4411e0a6c664ebd480';
    if (!await launch(_url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch website'),
        ),
      );
    }
  }
}
