import 'package:flutter/material.dart';


class BuildRichText extends StatelessWidget {
  final String title, description;
  //final bool haveUrl;
  const BuildRichText({
    @required this.title,
    @required this.description,
    //this.haveUrl,
  });


  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        text: title,
        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        children: <TextSpan>[
          new TextSpan(text: description, style: TextStyle(fontWeight: FontWeight.normal)),
          // haveUrl?
          // new TextSpan(
          //   text: '\n\nRead more...',
          //   style: new TextStyle(color: Colors.black54),
          //   recognizer: new TapGestureRecognizer()
          //     ..onTap = () {
          //       launch(AppConstants.ref_link);
          //     },
          // ):TextSpan(),

        ],
      ),
    );
  }
}
