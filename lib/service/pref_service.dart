import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_notice_bubt_client/utils/constant.dart';
import 'package:smart_notice_bubt_client/utils/extensions.dart';

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

// Receive Notification
void setReceiveNotification(bool value) {
  PrefService.prefs.setBool('receive_notification', value);
}

bool getReceiveNotification() {
  bool result = PrefService.prefs.getBool('receive_notification',)??true;
  return result;
}

// Load Image
void setLoadImage(bool value) {
  PrefService.prefs.setBool('load_image', value);
}

bool getLoadImage() {
  bool result = PrefService.prefs.getBool('load_image',)??true;
  return result;
}

// Cash Image
void setCacheImage(bool value) {
  PrefService.prefs.setBool('cash_image', value);
}

bool getCacheImage() {
  bool result = PrefService.prefs.getBool('cash_image',)??false;
  return result;
}


// Widget Update Interval
void setWidgetUpdateInterval(int value) {
  PrefService.prefs.setInt('widget_update_interval', value);
}

int getWidgetUpdateInterval() {
  int result = PrefService.prefs.getInt('widget_update_interval',)??30;
  return result;
}

// Notice Event Item Click
bool setCardClick() {
  int counter = getCardClick();
  if(counter>=3) counter = 0;
  else counter ++;
  PrefService.prefs.setInt('itemClick', counter);
  return getAppPurchase()?false:counter==0;
}

int getCardClick() {
  int result = PrefService.prefs.getInt('itemClick',)??0;
  return result;
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

void  setProUnlock(bool value) {
  if(!value){
    callPlatformMethod(30);
    setCacheImage(false);
    setAPPTheme(light);
    setProUnlockTime('0');
  }else{
    setCacheImage(true);
  }
  PrefService.prefs.setBool('pro_unlock', value);
}

bool getProUnlock() {
  bool result = PrefService.prefs.getBool('pro_unlock')??false;
  return result;
}
