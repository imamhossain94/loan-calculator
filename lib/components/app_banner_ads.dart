import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loan_calculator/service/pref_service.dart';
import 'package:loan_calculator/utils/constant.dart';

class AppBannerAds extends StatefulWidget {
  @override
  _AppBannerAdsState createState() => _AppBannerAdsState();
}

class _AppBannerAdsState extends State<AppBannerAds> {
  BannerAd _bannerAd;
  bool purchaseStatus;

  @override
  void initState() {
    purchaseStatus = getAppPurchase();
    if(!purchaseStatus){
      initBannerAds();
    }
    super.initState();
  }

  @override
  void dispose() {
    if(!purchaseStatus){
      _bannerAd?.dispose();
      _bannerAd = null;
    }
    super.dispose();
  }

  void initBannerAds() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnit,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {

    AdWidget adWidget;
    if(!purchaseStatus){
      adWidget = AdWidget(ad: _bannerAd);
    }

    return !purchaseStatus?Container(
      alignment: Alignment.center,
      child: adWidget,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      color: Colors.transparent,
    ):SizedBox();
  }
}


