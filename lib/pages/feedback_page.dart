import 'package:flutter/material.dart';

class FeedBackPage extends StatelessWidget {
  const FeedBackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'METAMAN BRIDGE',
              textScaleFactor: 2.0,
            ),
            Text(
              'Coming Soon',
              textScaleFactor: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
