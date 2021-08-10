import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async{
    await Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacementNamed(context, '/home');
    });
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Row(
          // crossAxisAlignment : CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/ic_launcher.png',
              height: 55, width: 55,),
            SizedBox(width: 10,),
            Text(
              'Mortgage\nCalculator',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Audiowide',
                fontSize: 24,
                decoration: TextDecoration.none,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );


  }
}
