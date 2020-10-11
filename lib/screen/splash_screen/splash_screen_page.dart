import 'package:flutter/material.dart';
import 'package:movie_app/resources/colors.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.splashScreenGreen,
      child: Center(
        child: Text(
          'Movies',
          style: TextStyle(
            color: Colors.black,
            fontSize: 60,
            fontFamily: 'Ethnocentric',
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
