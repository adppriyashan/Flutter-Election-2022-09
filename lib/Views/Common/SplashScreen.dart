import 'dart:async';

import 'package:election_app/Models/Colors.dart';
import 'package:election_app/Views/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:election_app/Models/Images.dart';
import 'package:election_app/Models/Strings.dart';
import 'package:election_app/Models/Utils.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils.displaySize = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Container(
        color: UtilColors.whiteColor ,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Utils.displaySize.width * 0.3,
                    width: Utils.displaySize.width * 0.5,
                    child: Image.asset(UtilImages.logoPNG),
                  ),
                  Text(
                    UtilStrings.appTitle,
                    style: GoogleFonts.openSans(
                        color: UtilColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 35.0),
                  ),
                  Text(
                    UtilStrings.appSubtitle,
                    style: GoogleFonts.openSans(
                      color: UtilColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  UtilStrings.splashScreen,
                  style: GoogleFonts.openSans(
                      color: UtilColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void startApp() async {
    _timer = Timer.periodic(
        const Duration(seconds: 3),
        (t) => Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (_) =>const HomeUser()),
            ));
  }
}
