import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:crypto_exchange/route_generator.dart';
import 'package:crypto_exchange/services/bsc_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BscService>(
          create: (_) => BscService(),
        ),
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
      ],
      child: MaterialApp(
        title: 'Crypto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Montserrat',
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: BscAddressPage.routeID,
      ),
    );
  }
}
