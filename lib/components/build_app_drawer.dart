import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mortgage_calculator/components/build_drawer_body_item.dart';
import 'package:mortgage_calculator/utils/app_constants.dart';
import 'package:mortgage_calculator/utils/extentsons.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildAppDrawer extends StatefulWidget {
  const BuildAppDrawer({
    Key key,
  }) : super(key: key);

  @override
  _BuildAppDrawerState createState() => _BuildAppDrawerState();
}

class _BuildAppDrawerState extends State<BuildAppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(width: 0.5, color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                blurRadius: 3,
                spreadRadius: 3,
                offset: Offset.zero)
          ]),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage("assets/images/ic_launcher.png"),
              //         fit: BoxFit.cover)),
              child: Row(
                // crossAxisAlignment : CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/ic_launcher.png',
                    height: 55,
                    width: 55,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppConstants.appNameNewLine,
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
            BuildDrawerBodyItem(
                icon: Icons.live_help_rounded,
                text: 'Help',
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, '/help');
                }),
            Divider(),
            // BuildDrawerBodyItem(
            //     icon: Icons.app_blocking_rounded,
            //     text: 'Remove Ads',
            //     onTap: () => null),
            BuildDrawerBodyItem(
                icon: Icons.rate_review,
                text: 'Rate The App',
                onTap: () {
                  //Navigator.pop(context);
                  onRatingPressed(context);
                }),
            BuildDrawerBodyItem(
                icon: Icons.share_rounded,
                text: 'Share',
                onTap: () {
                  Share.share(
                      'Hey check out this android app ${dotenv.env['SHARE_APP_LINK']}');
                }),
            Divider(),
            BuildDrawerBodyItem(
                icon: Icons.android_rounded,
                text: 'Other Apps',
                onTap: () async {
                  String url = dotenv.env['OTHER_APPS_LINK'];

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
            BuildDrawerBodyItem(
                icon: Icons.contact_mail,
                text: 'Contact',
                onTap: () async {
                  String url = dotenv.env['CONTACT_MAIL'];

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
            BuildDrawerBodyItem(
                icon: Icons.info_rounded,
                text: 'About',
                onTap: () async {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                }),
          ],
        ),
      ),
    );
  }
}
