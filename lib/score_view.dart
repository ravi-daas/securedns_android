// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cygiene_ui/views/widgets/score_card_widget_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_device/safe_device.dart';
import 'package:screen_lock_check/screen_lock_check.dart';
import 'views/widgets/animated_counter_widget_view.dart';
import 'constants/colors.dart';

var parameters_list = [];
var parameters_val = [];
var parameters_value = [];

class ScoreView extends StatefulWidget {
  const ScoreView({super.key});

  @override
  State<ScoreView> createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  MethodChannel bluetoothChannel =
      const MethodChannel("samples.flutter.dev/bluetooth");
  MethodChannel gpsChannel = const MethodChannel("samples.flutter.dev/gps");
  MethodChannel nfcChannel = const MethodChannel("samples.flutter.dev/nfc");
  int score = 0;
  bool unknown_status = false;
  bool nfcStatus = false;
  bool gps_enabled = false;
  bool bluetoothStatus = false;
  bool _isJailBroken = false;
  bool isDevelopmentModeEnable = false;
  bool _isScreenLockEnabled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      initPlatformState();
      scoreCard();
      getBluetoothStatus();
      getGpsStatus();
      getNfcStatus();
    });
  }

  /// The function initializes the platform state by checking if the device is jailbroken, if development
  /// mode is enabled, and if the screen lock is enabled.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> initPlatformState() async {
    bool isScreenLockEnabled = false;
    bool isJailBroken = false;
    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      parameters_list.add('Rooted_device');
      parameters_val.add(50);
      parameters_value.add(isJailBroken);

      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      parameters_list.add('Developer_options');
      parameters_val.add(20);
      parameters_value.add(isDevelopmentModeEnable);

      isScreenLockEnabled = await ScreenLockCheck().isScreenLockEnabled;
      parameters_list.add('Screen_lock');
      parameters_val.add(0);
      parameters_value.add(isScreenLockEnabled);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    setState(() {
      _isJailBroken = isJailBroken;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
      _isScreenLockEnabled = isScreenLockEnabled;
    });
  }

  /// The function `getBluetoothStatus` retrieves the current status of the Bluetooth and updates the
  /// state of the application.
  Future getBluetoothStatus() async {
    bluetoothStatus = await bluetoothChannel.invokeMethod("getBluetoothStatus");
    parameters_list.add('Bluetooth status');
    parameters_val.add(10);
    parameters_value.add(bluetoothStatus);
    setState(() {});
  }

  /// The function `getGpsStatus` retrieves the GPS status and updates the state with the result.
  Future getGpsStatus() async {
    gps_enabled = await gpsChannel.invokeMethod("getGpsStatus");
    parameters_list.add('Location');
    parameters_val.add(10);
    parameters_value.add(gps_enabled);
    setState(() {});
  }

  /// The function `getNfcStatus` retrieves the NFC status and updates the state with the result.
  Future getNfcStatus() async {
    nfcStatus = await nfcChannel.invokeMethod("getNfcStatus");
    parameters_list.add('NFC status');
    parameters_val.add(10);
    parameters_value.add(nfcStatus);
    setState(() {});
  }

  /// The function "scoreCard" updates the score variable and triggers a state update.
  Future scoreCard() async {
    score = screen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          )),
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          title: const Text(
            'Cygiene Score',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 1, 61, 84),
            ),
          ),
          automaticallyImplyLeading: true,
        ),
        body: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 1),
            ),
            Stack(
              children: [
                Lottie.asset(
                  "assets/white.json",
                  fit: BoxFit.cover,
                ),
                Lottie.asset(
                  "",
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .14,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 180,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 6, 111, 173),
                        ),
                        color: const Color.fromARGB(255, 6, 111, 173),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        // child: Countup(begin: 0, end: 10, duration: Duration(seconds: 3 , )),
                        child: AnimatedCountingText(
                          targetScore: score,
                          duration: const Duration(
                            seconds: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ScoreCardWidgetView(
                title: "Rooted device : ${_isJailBroken ? "Yes" : "No"}",
                checker: _isJailBroken,
                description:
                    'Rooting a smartphone gives you more control and customization options, but it also increases the risk of security vulnerabilities, voids the device warranty, and can lead to unstable performance. It may also cause compatibility issues with official updates and certain apps.'),
            ScoreCardWidgetView(
                title:
                    "Screen Lock : ${_isScreenLockEnabled ? "Enabled" : "Disabled"}",
                checker: _isScreenLockEnabled,
                description:
                    'Disabling the screen lock on a smartphone increases the risk of unauthorized access to personal data, including sensitive information, messages, and accounts. It also exposes the device to potential data theft, financial risks, and privacy breaches. Keeping a strong screen lock enabled is crucial for maintaining the security and privacy of your smartphone.'),
            ScoreCardWidgetView(
                title:
                    "Developer options : ${isDevelopmentModeEnable ? "Enabled" : "Disabled"}",
                checker: isDevelopmentModeEnable,
                description:
                    'Enabling Developer Options on a smartphone provides advanced features and customization options but comes with risks. These risks include system instability, potential security vulnerabilities, inadvertent modifications to critical settings, compatibility issues with apps, and the possibility of voiding the device warranty. It is important to understand the implications and have expertise before enabling and making changes in the Developer Options menu.'),
            ScoreCardWidgetView(
                title: "Nfc status : ${nfcStatus ? "Enabled" : "Disabled"}",
                checker: nfcStatus,
                description:
                    'NFC (Near Field Communication) on smartphones allows for convenient wireless communication, but it also carries risks. These risks include unauthorized data access, malware and malicious tags, data leakage and privacy concerns, and the potential for unauthorized transactions. Users should be cautious, disable NFC when not in use, and take necessary security measures to mitigate these risks.'),
            ScoreCardWidgetView(
                title: "Location : ${gps_enabled ? "Enabled" : "Disabled"}",
                checker: gps_enabled,
                description:
                    'Using location services on smartphones can be beneficial but comes with risks. These risks include privacy concerns, unauthorized tracking and access, potential data breaches, personal safety risks, and battery drain. Users should carefully manage app permissions, use location services selectively, and regularly review and adjust location settings to mitigate these risks.'),
            ScoreCardWidgetView(
                title:
                    "Bluetooth Status: ${bluetoothStatus ? "Enabled" : "Disabled"}",
                checker: bluetoothStatus,
                description:
                    'Bluetooth technology on smartphones offers wireless connectivity but carries risks. These risks include security vulnerabilities, unauthorized access or device impersonation, interception of data, bluejacking and bluesnarfing, as well as potential battery drain. To mitigate these risks, users should disable Bluetooth when not in use, use strong security measures when pairing devices, keep software up to date, and exercise caution when accepting connections or file transfers.'),
          ],
        ),
      ),
    );
  }
}

int screen() {
  int safetyCount = 0;
  int totalCount = 0;

  for (int i = 0; i < parameters_list.length; i++) {
    totalCount += parameters_val[i] as int;
    if (parameters_value[i].toString() == 'true') {
    } else if (parameters_value[i].toString() == "false") {
      safetyCount += parameters_val[i] as int;
    } else {}
  }
  parameters_list = [];
  parameters_val = [];
  parameters_value = [];
  return (((safetyCount / totalCount) * 10).round());
}
