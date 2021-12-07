import 'package:crypto_exchange/pages/feedback_page.dart';
import 'package:crypto_exchange/pages/home_page.dart';
import 'package:crypto_exchange/pages/poll_page.dart';
import 'package:crypto_exchange/pages/setting_page.dart';
import 'package:crypto_exchange/services/token_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BscWalletPage extends StatefulWidget {
  static const String routeID = 'bsc_wallet_page';
  const BscWalletPage({Key? key}) : super(key: key);

  @override
  State<BscWalletPage> createState() => _BscWalletPageState();
}

class _BscWalletPageState extends State<BscWalletPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokenService = Provider.of<TokenService>(context);
    final userService = Provider.of<UserService>(context);

    List<Widget> _widgetOptions = <Widget>[
      const HomePage(),
      const FeedBackPage(),
      const PollPage(),
      const SettingPage(),
    ];
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(tokenService, userService),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget _bottomNavigationBar(
      TokenService tokenService, UserService userService) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.feed_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/trade.png',
            width: 24.0,
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.black,
      onTap: (int index) {
        if (index == 0) {
          tokenService.tokenLoading = true;
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      selectedLabelStyle: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
      elevation: 10.0,
    );
  }
}
