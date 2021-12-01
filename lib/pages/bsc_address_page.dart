import 'package:flutter/material.dart';

class BscServicePage extends StatelessWidget {
  const BscServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton(
        onPressed: () {},
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.decal,
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.purple.withOpacity(0.35),
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Your BSC Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2.0, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
