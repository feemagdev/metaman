import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:crypto_exchange/route_generator.dart';
import 'package:crypto_exchange/services/token_service.dart';
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
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
        ChangeNotifierProvider<TokenService>(
          create: (_) => TokenService(),
        ),
      ],
      child: MaterialApp(
        title: 'Meta Man',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat',
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: BscAddressPage.routeID,
      ),
    );
  }
}
