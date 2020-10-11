import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('SplashScreen build');
    return Container(
      color: Colors.green,
      child: Center(
        child: Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: 'ITCAvantGardeStd',
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
