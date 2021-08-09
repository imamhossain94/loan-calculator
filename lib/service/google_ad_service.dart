import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdService {

  static RewardedAd rewardedAd;
  static bool rewardedReady = false;
  int maxFailedLoadAttempts = 3;
  int _numRewardedLoadAttempts;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );


  void initRewardedAd() async {

    _numRewardedLoadAttempts = 0;
    createRewardedAd();

  }

  void createRewardedAd() {
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
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }


  Future<bool> showRewardedAd() async{
    bool isSuccesses;
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      isSuccesses = false;
    }

    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
        isSuccesses = false,
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        isSuccesses = false;
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        isSuccesses = false;
        ad.dispose();
        createRewardedAd();
      },
    );

    rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      isSuccesses = true;
    });
    rewardedAd = null;

    return isSuccesses;
  }

  void disposeReword() {
    rewardedAd?.dispose();
  }


}


