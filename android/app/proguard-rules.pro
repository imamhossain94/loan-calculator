# Flutter engine + plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# The Flutter embedding references Play Core's deferred-component APIs, but this
# app does not use deferred components and does not ship play:core. Without
# these rules R8 fails the release build on the missing classes.
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-dontwarn com.google.android.gms.**

# printing / pdf
-keep class net.nfet.flutter.printing.** { *; }

# androidx.work / Room
# WorkManager (a transitive dependency of play-services-ads) instantiates its
# Room database via Class.forName("...WorkDatabase_Impl"). R8 cannot see that
# reflective reference and strips the class, which crashes the app at startup.
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep @androidx.room.Database class * { *; }
-dontwarn androidx.room.**
-dontwarn androidx.work.**
