import 'package:crypto_exchange/pages/bottom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNamePage extends StatelessWidget {
  static const String routeID = 'username_page';
  final TextEditingController _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: OutlinedButton(
          onPressed: () async {
            SharedPreferences _sharedPreferences =
                await SharedPreferences.getInstance();
            _sharedPreferences.setString('user_name', _userNameController.text);

            _moveToWalletPage(context);
          },
          child: const Text(
            'DONE',
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.purple.withOpacity(0.2),
                Colors.white.withOpacity(0.5)
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
                    'WELCOME TO',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'META MAN!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Hey! What do we call you?',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          hintText: 'Your Name',
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

  void _moveToWalletPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(BscWalletPage.routeID);
  }
}
