import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class GoogleAdService {

  static RewardedAd rewardedAd;
  static bool rewardedReady = false;
  static int maxFailedLoadAttempts = 3;


  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );


  Future init() async {
    createRewardedAd();
  }

  static void createRewardedAd() {
    int _numRewardedLoadAttempts = 0;
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            print(_numRewardedLoadAttempts);
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        )
    );
  }

}

bool isSuccesses;

Future<bool> showRewardedAd() async{

  if (GoogleAdService.rewardedAd == null) {
     return false;
  }

  GoogleAdService.rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedAd ad) async {},
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
      GoogleAdService.createRewardedAd();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      GoogleAdService.createRewardedAd();
    },
  );

  await GoogleAdService.rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {});
  GoogleAdService.rewardedAd = null;

  return true;
}

void disposeReword() {
  GoogleAdService.rewardedAd?.dispose();
}

