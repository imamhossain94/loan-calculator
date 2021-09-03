import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loan_calculator/utils/constant.dart';

class GoogleAdService {
  // Interstitial Ads
  static InterstitialAd interstitialAd;
  static bool interstitialReady = false;

  static int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  Future init() async {
    createInterstitialAd();

  }

  static void createInterstitialAd() {
    int numInterstitialLoadAttempts = 0;
    InterstitialAd.load(
        adUnitId: interstitialAdUnit,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        )
    );
  }

}


Future<bool> showInterstitialAd(String url) async{
  if (GoogleAdService.interstitialAd == null) {
    //Browser().openBrowser(url);
    return false;
  }
  GoogleAdService.interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) {},
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      GoogleAdService.createInterstitialAd();
      //Browser().openBrowser(url);
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      GoogleAdService.createInterstitialAd();
      //Browser().openBrowser(url);
    },
  );
  GoogleAdService.interstitialAd.show();
  GoogleAdService.interstitialAd = null;

  return true;
}


void disposeGoogleAdService() {
  GoogleAdService.interstitialAd?.dispose();
}

