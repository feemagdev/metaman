import 'package:crypto_exchange/pages/feedback_page.dart';
import 'package:crypto_exchange/pages/home_page.dart';
import 'package:crypto_exchange/pages/poll_page.dart';
import 'package:crypto_exchange/pages/setting_page.dart';
import 'package:flutter/material.dart';

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
    List<Widget> _widgetOptions = <Widget>[
      const HomePage(),
      const FeedBackPage(),
      const PollPage(),
      const SettingPage(),
    ];
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.purple[800],
      unselectedItemColor: Colors.black,
      onTap: _onItemTapped,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      selectedLabelStyle: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
      elevation: 10.0,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
