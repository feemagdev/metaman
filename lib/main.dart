import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:crypto_exchange/services/bsc_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BscService>(
      create: (_) => BscService(),
      child: MaterialApp(
        title: 'Crypto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Montserrat',
        ),
        home: BscServicePage(),
      ),
    );
  }
}
