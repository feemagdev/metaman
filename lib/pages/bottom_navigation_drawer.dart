import 'package:crypto_exchange/pages/feedback_page.dart';
import 'package:crypto_exchange/pages/home_page.dart';
import 'package:crypto_exchange/pages/poll_page.dart';
import 'package:crypto_exchange/pages/setting_page.dart';
import 'package:crypto_exchange/services/token_service.dart';
import 'package:crypto_exchange/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: FaIcon(
            FontAwesomeIcons.home,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(Icons.track_changes_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: FaIcon(
            FontAwesomeIcons.coins,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (index == 0) {
          tokenService.tokenLoading = true;
        } else if (index == 1) {
          tokenService.metaManInfoLoading = true;
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      elevation: 5.0,
    );
  }
}
