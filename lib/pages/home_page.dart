import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hi Name',
            textScaleFactor: 1.3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            width: size.width,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Portfolio',
                    textScaleFactor: 1.5,
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
                    textScaleFactor: 1.3,
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
                    textScaleFactor: 2.0,
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
                        textScaleFactor: 1.3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Text(
                        '|',
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1.3,
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
                            textScaleFactor: 1.3,
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
          ),
        ],
      ),
    );
  }
}
