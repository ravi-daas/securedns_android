import 'dart:ui';

import 'package:cygiene_ui/views/widgets/animated_counter_widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:safe_device/safe_device.dart';
import 'dart:async';
import 'package:screen_lock_check/screen_lock_check.dart';

var parameters_list = [];
var parameters_val = [];
var parameters_value = [];

class parameters_logic extends StatefulWidget {
  const parameters_logic({super.key});

  @override
  State<parameters_logic> createState() => _parameters_logicState();
}

class _parameters_logicState extends State<parameters_logic> {
  MethodChannel bluetoothChannel =
      MethodChannel("samples.flutter.dev/bluetooth");
  MethodChannel gpsChannel = MethodChannel("samples.flutter.dev/gps");
  MethodChannel nfcChannel = MethodChannel("samples.flutter.dev/nfc");
  // MethodChannel updateChannel =  MethodChannel("samples.flutter.dev/update");
  // MethodChannel locationChannel = MethodChannel("samples.flutter.dev/gps_enable");
  int score = 0;
  bool unknown_status = false;
  bool nfcStatus = false;
  bool gps_enabled = false;
  bool bluetoothStatus = false;
  bool _isJailBroken = false;
  bool isDevelopmentModeEnable = false;
  bool _isScreenLockEnabled = false;

  @override
 

  @override
  void initState() {
    super.initState();
    setState(() {
      initPlatformState();
      score_card();
      getBluetoothStatus();
      getGpsStatus();
      getNfcStatus();
    });
  }

  Future<void> initPlatformState() async {
    bool isScreenLockEnabled = false;
    // bool isLocationServiceEnabled = true;
    bool isJailBroken = false;
    // await LocationPermissions().requestPermissions();
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
      print(error);
    }

    setState(() {
      _isJailBroken = isJailBroken;

      // canMockLocation = canMockLocation;
      // isRealDevice = isRealDevice;
      // isOnExternalStorage = isOnExternalStorage;
      // isSafeDevice = isSafeDevice;
      isDevelopmentModeEnable = isDevelopmentModeEnable;
      _isScreenLockEnabled = isScreenLockEnabled;
      // _isLocationServiceEnabled = isLocationServiceEnabled;
    });
  }

  Future getBluetoothStatus() async {
    bluetoothStatus = await bluetoothChannel.invokeMethod("getBluetoothStatus");
    parameters_list.add('Bluetooth status');
    parameters_val.add(10);
    parameters_value.add(bluetoothStatus);

  }

  Future getGpsStatus() async {
    gps_enabled = await gpsChannel.invokeMethod("getGpsStatus");
    parameters_list.add('Location');
    parameters_val.add(10);
    parameters_value.add(gps_enabled);
   
  }

  Future getNfcStatus() async {
    nfcStatus = await nfcChannel.invokeMethod("getNfcStatus");
    parameters_list.add('NFC status');
    parameters_val.add(10);
    parameters_value.add(nfcStatus);
   
  }

  Future score_card() async {
    score = screen();
    setState(() {});
  }

  final Color enabledColor = Color.fromARGB(255, 6, 192, 12);
  final Color disabledColor = Colors.redAccent;

// AnimationController _controller;
// Animation<double> _animation;
  @override
  Widget build(BuildContext context) {
    // return AppLifecycleEventHandler(
    //   setIsScreenLockEnabled: (val) {
    //     setState(() {
    //       _isScreenLockEnabled = val;
    //     });
    //   },
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 6, 111, 173),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          )),
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          title: const Text(
            'Cygiene Score',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 1, 61, 84),
            ),
          ),
        ),
        body: ListView(children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 0),
          ),

          Stack(
            children: [
              Lottie.asset(
                "assets/white.json",
                fit: BoxFit.cover,
              ),
              Lottie.asset("assets/white.json", fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .10,
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

          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: ExpansionTile(
                leading: const Icon(
                  Icons.android,
                  color: Color.fromARGB(255, 44, 41, 41),
                  size: 35,
                ),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Rooted device : ',
                        style: TextStyle(
                            color: Colors.blue), // Keep the same color
                      ),
                      TextSpan(
                          text: _isJailBroken ? "Yes" : "No",
                          style: TextStyle(
                              color: _isJailBroken
                                  ? disabledColor
                                  : enabledColor)),
                    ],
                  ),
                ),
                children: <Widget>[
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25)),

                    // borderRadius: BorderRadius.circular(15),

                    title: const Text(
                      'Rooting a smartphone gives you more control and customization options, but it also increases the risk of security vulnerabilities, voids the device warranty, and can lead to unstable performance. It may also cause compatibility issues with official updates and certain apps.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 61, 84),
                        fontSize: 15.0,
                      ),
                      //   colors: const [
                      //     Colors.blue,
                      //     Colors.black,
                      //     Colors.teal,
                      //   ],
                      // ),
                    ),
                  )
                ]),
          ),

          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25)),
            child: ExpansionTile(
                leading: const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 44, 41, 41),
                  size: 35,
                ),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Screen Lock : ',
                        style: TextStyle(
                            color: Colors.blue), // Keep the same color
                      ),
                      TextSpan(
                          text: _isScreenLockEnabled ? "Enabled" : "Disabled",
                          style: TextStyle(
                              color: _isScreenLockEnabled
                                  ? enabledColor
                                  : disabledColor)),
                    ],
                  ),
                ),
                children: <Widget>[
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      '''Disabling the screen lock on a smartphone increases the risk of unauthorized access to personal data, including sensitive information, messages, and accounts. It also exposes the device to potential data theft, financial risks, and privacy breaches. Keeping a strong screen lock enabled is crucial for maintaining the security and privacy of your smartphone.

To enable screen lock on a smartphone:

1. Open "Settings" and go to "Security" or "Lock Screen."

2. Choose the type of screen lock (PIN, password, pattern, or biometrics) and set it up.''',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 61, 84), fontSize: 15),
                    ),
                  ),
                ]),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: ExpansionTile(
              leading: const Icon(
                Icons.developer_mode,
                color: Color.fromARGB(255, 44, 41, 41),
                size: 35,
              ),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Developer Options: ',
                      style:
                          TextStyle(color: Colors.blue), // Keep the same color
                    ),
                    TextSpan(
                        text: isDevelopmentModeEnable ? "Enabled" : "Disabled",
                        style: TextStyle(
                            color: isDevelopmentModeEnable
                                ? disabledColor
                                : enabledColor)),
                  ],
                ),
              ),
              children: <Widget>[
                ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      '''Enabling Developer Options on a smartphone provides advanced features and customization options but comes with risks. These risks include system instability, potential security vulnerabilities, inadvertent modifications to critical settings, compatibility issues with apps, and the possibility of voiding the device warranty. It is important to understand the implications and have expertise before enabling and making changes in the Developer Options menu.

To disable Developer Options on a smartphone:

1. Open "Settings" and go to "System" or "About phone."

2. Look for "Developer Options" and toggle it off.''',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 61, 84), fontSize: 15),
                    )),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: ExpansionTile(
              leading: const Icon(
                Icons.nfc_outlined,
                color: Color.fromARGB(255, 44, 41, 41),
                size: 35,
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'NFC: ',
                      style:
                          TextStyle(color: Colors.blue), // Keep the same color
                    ),
                    TextSpan(
                        text: nfcStatus ? "Enabled" : "Disabled",
                        style: TextStyle(
                            color: nfcStatus ? disabledColor : enabledColor)),
                  ],
                ),
              ),
              children: <Widget>[
                ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      '''NFC (Near Field Communication) on smartphones allows for convenient wireless communication, but it also carries risks. These risks include unauthorized data access, malware and malicious tags, data leakage and privacy concerns, and the potential for unauthorized transactions. Users should be cautious, disable NFC when not in use, and take necessary security measures to mitigate these risks.
                      
To disable NFC on a smartphone:

1. Open "Settings" and go to "Connections" or "Wireless & Networks."

2. Find "NFC" or "NFC and Payment" and toggle it off.''',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 61, 84), fontSize: 15),
                    ))
              ],
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: ExpansionTile(
              leading: const Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 44, 41, 41),
                size: 35,
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Location: ',
                      style:
                          TextStyle(color: Colors.blue), // Keep the same color
                    ),
                    TextSpan(
                        text: gps_enabled ? "Enabled" : "Disabled",
                        style: TextStyle(
                            color: gps_enabled ? disabledColor : enabledColor)),
                  ],
                ),
              ),
              children: [
                ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      '''Using location services on smartphones can be beneficial but comes with risks. These risks include privacy concerns, unauthorized tracking and access, potential data breaches, personal safety risks, and battery drain. Users should carefully manage app permissions, use location services selectively, and regularly review and adjust location settings to mitigate these risks.
                      
To disable location services on a smartphone:

1. Open "Settings" and go to "Privacy" or "Location."

2. Toggle off the "Location" or "Location Services" option.''',
                      style: TextStyle(
                        color: Color.fromARGB(255, 1, 61, 84),
                        fontSize: 15,
                      ),
                    ))
              ],
            ),
          ),
          // Card(
          //   color: Color.fromARGB(255, 1, 61, 84),
          //   shape: RoundedRectangleBorder(
          //       side: BorderSide(
          //         color: Color.fromARGB(255, 1, 61, 84),
          //       ),
          //       borderRadius: BorderRadius.circular(20)),
          //   child: ListTile(
          //     title: Text(
          //       'Notification on lock screen : ${isDevelopmentModeEnable ? "Yes" : "No"} ',
          //       style: const TextStyle(color: Colors.white, fontSize: 15),
          //     ),
          //     leading: const Icon(
          //       Icons.notifications,
          //       color: Colors.white,
          //       size: 35,
          //     ),
          //   ),
          // ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: ExpansionTile(
              leading: const Icon(
                Icons.bluetooth,
                color: Color.fromARGB(255, 44, 41, 41),
                size: 35,
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Bluetooth Status: ',
                      style:
                          TextStyle(color: Colors.blue), // Keep the same color
                    ),
                    TextSpan(
                        text: bluetoothStatus ? "Enabled" : "Disabled",
                        style: TextStyle(
                            color: bluetoothStatus
                                ? disabledColor
                                : enabledColor)),
                  ],
                ),
              ),
              children: [
                ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      '''Bluetooth technology on smartphones offers wireless connectivity but carries risks. These risks include security vulnerabilities, unauthorized access or device impersonation, interception of data, bluejacking and bluesnarfing, as well as potential battery drain. To mitigate these risks, users should disable Bluetooth when not in use, use strong security measures when pairing devices, keep software up to date, and exercise caution when accepting connections or file transfers.

To disable Bluetooth on a smartphone:
                      
1. Open "Settings" and go to "Connections" or "Bluetooth."

2. Toggle off the "Bluetooth" switch.''',
                      style: TextStyle(
                          color: Color.fromARGB(255, 1, 61, 84), fontSize: 15),
                    ))
              ],
            ),
          )

          // Card(
          //   shape: RoundedRectangleBorder(side: BorderSide(color:Colors.blue), borderRadius: BorderRadius.circular(20)),
          //   child: ListTile(
          //      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
//               shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue, width:1, ),
//     // borderRadius: BorderRadius.circular(15),
// ),
          //     title: Text(
          //       'Unknown Sources : ${unknown_status ? "Enabled" : "Disabled"} ',
          //       style: const TextStyle(color: Colors.blue, fontSize: 15),
          //     ),
          //     leading: const Icon(
          //       Icons.location_on,
          //       color: Colors.blue,
          //       size: 40,
          //     ),
          //     tileColor: Color.fromARGB(255, 1, 61, 84),,
          //   ),
          // ),
          // Card(
          //   elevation: 4 ,
          //   shadowColor: Colors.blue,
          //   shape: RoundedRectangleBorder(side: BorderSide(color:Colors.blue), borderRadius: BorderRadius.circular(20)),
          //   child: ListTile(

          //      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),

          //     title: Text(
          //       'Cygiene Score: $score/10',
          //       style: TextStyle(color: Colors.blue, fontSize: 15),
          //     ),
          //     leading: const Icon(
          //       Icons.location_on,
          //       color: Colors.blue,
          //       size: 40,
          //     ),
          //     tileColor: Color.fromARGB(255, 1, 61, 84),,
          //   ),
          // ),

          // ElevatedButton(onPressed: score_card, child: Text('Scan'), )
          // ElevatedButton.icon(onPressed: score_card, icon: Icon(Icons.adf_scanner , color: Colors.white,,), label: Text('Scan'), ),
          // ElevatedButton(onPressed: score_card, child: null , ),
          // ElevatedButton(
          // child: Text('$score'),
          // onPressed: () => score_card(),
        ]),
        // ignore: prefer_const_constructors
        // floatingActionButton: FloatingActionButton.extended(
        //   label: const Text(
        //     'Scan',
        //     style: TextStyle(
        //       color: Color.fromARGB(255, 1, 61, 84),
        //     ),
        //   ),
        //   backgroundColor: Colors.white,

        //   shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(80))),
        //   onPressed: (() {
        // score_card();
        // getBluetoothStatus();
        // getGpsStatus();
        // getNfcStatus();
        // }),

        // child: SizedBox(child: Text('Scan', style: TextStyle(fontSize: 20),), ),
        // child: Text('Scan'),
        // onPressed: () {score_card();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const Homepage()));
        // },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

int screen() {
  //  var parameters_li = parameters_list;
  //  var parameters_vale = parameters_value;
  //  var parameters_v= parameters_val;
  int riskCount = 0;
  int safetyCount = 0;
  int totalCount = 0;

  for (int i = 0; i < parameters_list.length; i++) {
    totalCount += parameters_val[i] as int;
    if (parameters_value[i].toString() == 'true') {
      riskCount += parameters_val[i] as int;
      // print('Risk : $risk_count');
    } else if (parameters_value[i].toString() == "false") {
      safetyCount += parameters_val[i] as int;
    } else {
      // print('ssm');
    }
  }

  // print('Par list : $parameters_list');
  // print('P_vslue: $parameters_value');
  // print('P_: $parameters_val');
  // print('Total count : $total_count');
  // print('Safety count : $safety_count');
  // print('Risk_count :$risk_count');
  // print((((safety_count / total_count) * 10).round()));
  // print(((risk_count / total_count) * 10).round());
  parameters_list = [];
  parameters_val = [];
  parameters_value = [];
// print((risk_count/total_count)*10);
  return (((safetyCount / totalCount) * 10).round());
}
