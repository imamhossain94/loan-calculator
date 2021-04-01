import 'package:flutter/material.dart';
import 'package:mortgage_calculator/components/build_qna.dart';
import 'package:mortgage_calculator/components/build_rich_text.dart';
import 'package:mortgage_calculator/utils/app_constants.dart';
import 'package:mortgage_calculator/utils/screen_config.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 2,
          title: Text(
            'Help',
            style: TextStyle(
                fontSize: responsiveText(22),
                fontFamily: 'Audiowide',
                color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(15),
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
            Expanded(
                child: Container(
              color: Colors.grey.withOpacity(0.1),
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  BuildQNA(
                    question: AppConstants.q1,
                    answer: AppConstants.a1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppConstants.e_fmp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          AppConstants.mc_eqn,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BuildRichText(
                          title: '• M = ',
                          description: AppConstants.t_t_mmp,
                          //haveUrl: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BuildRichText(
                          title: '• P = ',
                          description: AppConstants.t_plm,
                          //haveUrl: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BuildRichText(
                          title: AppConstants.r_y_mir,
                          description: AppConstants.r_y_mir_d,
                          //haveUrl: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BuildRichText(
                          title: AppConstants.n_n_pll,
                          description: AppConstants.n_n_pll_d,
                          //haveUrl: false,
                        ),
                      ],
                    ),
                  ),

                  // Other QNA ---
                  BuildQNA(
                    question: AppConstants.q2,
                    answer: AppConstants.a2,
                  ),
                  BuildQNA(
                    question: AppConstants.q3,
                    answer: AppConstants.a3,
                  ),
                  BuildQNA(
                    question: AppConstants.q4,
                    answer: AppConstants.a4,
                  ),
                  BuildQNA(
                    question: AppConstants.q5,
                    answer: AppConstants.a5,
                  ),
                  BuildQNA(
                    question: AppConstants.q6,
                    answer: AppConstants.a6,
                  ),
                  BuildQNA(
                    question: AppConstants.q7,
                    answer: AppConstants.a7,
                  ),
                  BuildQNA(
                    question: AppConstants.q8,
                    answer: AppConstants.a8,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
