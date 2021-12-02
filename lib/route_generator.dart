import 'package:crypto_exchange/pages/bottom_navigation_drawer.dart';
import 'package:crypto_exchange/pages/bsc_address_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case BscWalletPage.routeID:
        return MaterialPageRoute(builder: (_) => const BscWalletPage());
      case BscAddressPage.routeID:
        return MaterialPageRoute(builder: (_) => BscAddressPage());
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
