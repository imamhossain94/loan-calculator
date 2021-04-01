import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';


class BuildRatingValue extends StatelessWidget {
  final int value;
  final Color color;
  const BuildRatingValue({Key key, this.value, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoButton(
        onPressed: () async {
          if (value <= 3) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/feedback');
          } else if (value <= 5) {
            Navigator.pop(context);
            String url = env['RATE_THE_APP_LINK'];

            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }
        },
        padding: EdgeInsets.zero,
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(value.toString()),
        ),
      ),
    );
  }
}
