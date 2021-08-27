import 'package:loan_calculator/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences prefs;
  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

// Themes
int getSavedTheme() {
  return themes.indexOf(PrefService.prefs.getString(appTheme) ?? systemDefault);
}


// Set App Theme
void setAPPTheme(String value) {
  PrefService.prefs.setString(appTheme, value);
}

String getAPPTheme() {
  return PrefService.prefs.getString(appTheme);
}


// App version
void setAppVersion(String value) {
  PrefService.prefs.setString('app_version', value);
}

String getAppVersion() {
  return PrefService.prefs.getString('app_version') ?? '0';
}


// App Pro Purchase
void setAppPurchase(bool value) {
  PrefService.prefs.setBool('app_purchase', value);
}

bool getAppPurchase() {
  bool result = PrefService.prefs.getBool('app_purchase')??false;
  return result;
}

void setProUnlockTime(String value) {
  PrefService.prefs.setString('pro_unlock_time', value);
}

String getProUnlockTime() {
  String result = PrefService.prefs.getString('pro_unlock_time')??'0';
  return result;
}
