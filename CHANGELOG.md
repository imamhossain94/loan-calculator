# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow [Semantic Versioning](https://semver.org/).

---

## [1.6.0+10] — 2026-08-21

Compliance release. Version 1.5.6 (code 9) was removed from Google Play in
February 2024 for violating the Personal Loans policy, and could not be updated
because it targeted API 31. This release resolves both, and rebuilds the app on
a current toolchain.

### Play policy compliance

- **Removed `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE`.** These were
  the cause of the removal. Confirmed present in the merged manifest of the
  shipped `app-release.aab` before the change, and absent after.
- **The app now requests no permissions at all.** The only entry in the merged
  manifest is `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, which AndroidX
  generates for its own internal receivers.
- Added `tools:node="remove"` guards for 22 permissions (storage, media,
  contacts, location, SMS, call log, phone state, camera, ad ID, billing,
  `QUERY_ALL_PACKAGES`). A transitive dependency can no longer reintroduce a
  banned permission without the build failing loudly.
- Removed `android:requestLegacyExternalStorage`.
- `targetSdkVersion` 31 → **36**, `minSdkVersion` 21 → **24**,
  `compileSdkVersion` 31 → 36.

### Added

- **Compare Loan.** Enter up to three sets of loan terms and see them side by
  side, ranked by total cost — interest plus up-front fees — so a low headline
  rate with a large arrangement fee cannot masquerade as the cheaper option.
  Highlights the lowest total cost and the lowest monthly payment separately.
- Material 3 design system with full light and dark theme support.
- Edge-to-edge system bars. Only icon brightness is declared; bar colours are
  deliberately not set, as they are ignored from Android 15 onward.
- Sharing via the Android share sheet for both result images and PDFs.
- PDF preview with built-in share and print, rendered from memory.
- Adaptive launcher icon with a `<monochrome>` layer for Android 13+ themed
  icons, plus a round icon for API 25.
- 15 unit tests covering the payment formula, comparison ranking, every
  everyday calculator, and currency formatting.
- `store/` folder: feature graphic, 512 icon, 7 captioned screenshots, listing
  copy and release notes.

### Removed

- **All advertising.** `google_mobile_ads`, banner and interstitial units, and
  the AdMob application ID. This also removed `AD_ID`, three
  `ACCESS_ADSERVICES_*` permissions, `WAKE_LOCK` and `FOREGROUND_SERVICE` from
  the merged manifest, and eliminated a startup crash (see below).
- **Gallery screen and all file saving.** Results were written to
  `/storage/emulated/0/Download/LoanCalculator/`, which required the banned
  storage permissions. Export now goes through the share sheet.
- `com.android.vending.BILLING` and the unused `in_app_purchase` dependency.
- Dependencies dropped: `permission_handler`, `device_info`, `package_info`,
  `share`, `flutter_email_sender`, `flutter_pdfview`, `in_app_purchase`,
  `provider`, `flutter_dotenv`, `font_awesome_flutter`, `google_mobile_ads`.
- The bundled `.env` asset, which held now-obsolete ad unit identifiers.

### Fixed

- **History deletion removed the wrong record.** The list was reversed for
  display but `box.deleteAt(index)` was called with the display index against
  the un-reversed box, so deleting row *n* destroyed a different entry. Box
  keys are now tracked alongside the display order.
- **`Hive.close()` permanently broke saved calculations.** It clears Hive's
  home path, so every later `openBox()` threw *"You need to initialize Hive"*.
  The box is now opened once at startup and stays open for the process
  lifetime.
- **Release builds crashed on launch.** `play-services-ads` pulled in
  `androidx.work` 2.7.0 / Room 2.2.5, whose generated `WorkDatabase_Impl` R8
  stripped. Resolved by removing ads; keep rules retained as a safeguard.
- Release builds were signed with the debug key (`CN=Android Debug`) and would
  have been rejected by Play. Signing now reads `android/key.properties`.
- Currency was formatted two different ways on the same card
  (`$ 147974.61` beside `$240,000.00`). All amounts share one formatter.
- `MainActivity` constructed a second `FlutterEngine` purely to register
  plugins, and installed an empty `MethodChannel` handler.
- Launcher icon: was ~11× oversized at every density, lived in `drawable/`
  instead of `mipmap/`, had rounded corners baked in (so the launcher masked an
  already-rounded shape), and had no adaptive or themed variant. Artwork is
  unchanged; packaging is now correct. Payload 408 KB → 164 KB.

### Changed

- Migrated the entire codebase to null safety: Dart `>=2.7.0 <3.0.0` → `^3.9.0`.
  47 Dart files reduced to 27 as dead screens and duplicated widgets were
  removed.
- Rebuilt the Android project: Gradle 6.7.1 → 9.1.0, AGP 4.2.2 → 9.0.1, Groovy
  → Kotlin DSL, jcenter removed, `namespace` declared, Java 17 target.
- `hive` / `hive_flutter` → `hive_ce` / `hive_ce_flutter` (the maintained fork;
  `hive` does not resolve under Dart 3). Box format, type IDs and field numbers
  are unchanged, so calculations saved by 1.5.6 still load.
- `share` → `share_plus`, `package_info` → `package_info_plus`,
  `flutter_pdfview` → `printing`.
- Calculation logic extracted from widgets into `lib/domain/`, making it
  testable independently of the UI. The bi-weekly model retains its original
  constants so figures stay consistent with saved results.
- US spelling throughout (`amortization`), matching the store listing.

### Migration notes

- `applicationId` remains `com.newagedevs.mortgage_calculator`. Do not change
  it; it identifies the published listing.
- `android/key.properties` is required for release builds and is git-ignored.
  See `android/key.properties.example`.
- Files written to Downloads by 1.5.6 remain on device. The app can no longer
  list them; the system Files app can.
- Ads were removed at the developer's request, not because policy required it.
  The Personal Loans policy bans specific permissions, not advertising. If ads
  are re-enabled, the "no permissions / no advertising" claims in the store
  listing must be updated in the same release.

---

## [1.5.6+9] — 2021-11

Last version published to Google Play. Removed by Google on 12 and 14 February
2024 under the Personal Loans policy. Retained here for reference.
