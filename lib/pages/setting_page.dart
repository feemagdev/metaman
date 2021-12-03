import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 2.0,
            colors: [
              Colors.purple.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const Text(
                'Options',
                textScaleFactor: 1.4,
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Settings',
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.purple,
                      ),
                      title: const Text('Change Currency'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.visibility_outlined,
                        color: Colors.purple,
                      ),
                      title: const Text('Token Visibility'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.purple,
                      ),
                      title: const Text('Clear App Data'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Help',
                textScaleFactor: 1.3,
                style: TextStyle(color: Colors.purple),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.help_outline,
                        color: Colors.purple,
                      ),
                      title: const Text('Help & Support'),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.report_outlined,
                        color: Colors.purple,
                      ),
                      title: const Text('About'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
