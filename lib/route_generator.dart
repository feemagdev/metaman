import 'package:crypto_exchange/pages/bottom_navigation_drawer.dart';
import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:crypto_exchange/pages/token_visibility_page.dart';
import 'package:crypto_exchange/pages/user_name_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case BscWalletPage.routeID:
        return MaterialPageRoute(builder: (_) => const BscWalletPage());
      case BscAddressPage.routeID:
        return MaterialPageRoute(builder: (_) => BscAddressPage());
      case UserNamePage.routeID:
        return MaterialPageRoute(builder: (_) => UserNamePage());
      case TokenVisibility.routeID:
        return MaterialPageRoute(builder: (_) => const TokenVisibility());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
