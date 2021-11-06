import 'package:flutter/material.dart';

import 'tabs/savings_tab.dart';
import 'tabs/simple_loan_tab.dart';
import 'tabs/tax_tab.dart';

class GalleryScreen extends StatefulWidget {
  static const String idScreen = "GalleryScreen";

  const GalleryScreen({Key key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
            appBar: AppBar(
              //centerTitle: true,
              titleSpacing: 0,
              title: Text(
                'Gallery',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              bottom: PreferredSize(
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.black.withOpacity(0.5),
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Text('Simple Loan',),
                        ),
                        Tab(
                          child: Text('Advanced Loan',),
                        ),
                        Tab(
                          child: Text('Savings'),
                        ),
                        Tab(
                          child: Text('Tax'),
                        ),
                        Tab(
                          child: Text('Discount'),
                        ),
                        Tab(
                          child: Text('Tip'),
                        ),
                      ]),
                  preferredSize: Size.fromHeight(30.0)),
            ),
            body: TabBarView(
              children: <Widget>[

                SimpleLoanTab(),
                Container(
                  child: Center(
                    child: Text('Tab 3'),
                  ),
                ),
                SavingsTab(),
                TaxTab(),

                Container(
                  child: Center(
                    child: Text('Tab 5'),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('Tab 6'),
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
