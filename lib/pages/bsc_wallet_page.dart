import 'package:flutter/material.dart';

class BscWalletPage extends StatelessWidget {
  const BscWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi Name',
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10.0,
              ),
              _balanceUI(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceUI(Size size) {
    return Container(
      width: size.width,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Portfolio',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Total USD Value',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              '\$12.00',
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.5,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'change in 24h',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Text(
                  '|',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      '0.0%',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
