import 'package:crypto_exchange/pages/bottom_navigation_drawer.dart';
import 'package:crypto_exchange/pages/user_name_page.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BscAddressPage extends StatelessWidget {
  static const String routeID = 'bsc_address_page';
  final TextEditingController _bscAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BscAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: true);

    if (userService.loading) {
      userService.getUserData();
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          ),
        ),
      );
    } else {
      if (userService.sharedPreferences.getKeys().isEmpty) {
        return _bscAddressUI(context);
      }
      return const BscWalletPage();
    }
  }

  void _moveToUserNamePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(UserNamePage.routeID);
  }

  Widget _bscAddressUI(context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: OutlinedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString(
                'bsc_address', _bscAddressController.text);

            _moveToUserNamePage(context);
          },
          child: const Text(
            'NEXT',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.only(
                top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
            side: const BorderSide(width: 1.0),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 2.0,
              colors: [
                Colors.purple.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.40,
                  ),
                  const Text(
                    'WELCOME TO META MAN!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Enter Your BSC Wallet Address to start tracking your holding',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _bscAddressController,
                        validator: (text) {
                          if (text == null) {
                            return 'Please Enter BSC address';
                          } else if (text.length == 42) {
                            return null;
                          } else if (text.length > 42) {
                            return 'Incorrect BSC address';
                          } else if (text.length < 42) {
                            return 'Incorrect BSC address';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Your BSC Address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 2.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
