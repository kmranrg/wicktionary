import 'package:flutter/material.dart';
import 'package:wicktionary/constants.dart';

class DeveloperTab extends StatefulWidget {
  @override
  _DeveloperTabState createState() => _DeveloperTabState();
}

class _DeveloperTabState extends State<DeveloperTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "asset/images/developer.png",
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "Designed & Developed By",
                style: myRegularTextStyle.copyWith(fontSize: 22.0),
              ),
            ),
            Text(
              "Kumar Anurag",
              style: myRegularTextStyle.copyWith(fontSize: 22.0),
            ),
            Text(
              "Instagram: kmranrg",
              style: myRegularTextStyle.copyWith(fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }
}
