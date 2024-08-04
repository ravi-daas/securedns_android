// ignore_for_file: prefer_function_declarations_over_variables, library_private_types_in_public_api
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygiene_ui/navigation/parameters_logic.dart';
import 'package:cygiene_ui/utils/token_manager.dart';
// import 'package:cygiene_ui/views/widgets/score_card_widget_view.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_wireguard_vpn/wireguard_vpn.dart';
import '../../providers/vpn_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cygiene_ui/utils/user_details.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}
// http://115.113.39.74:65528/api/user/wireguardapi

class _HomeViewState extends State<HomeView> {
  final _wireguardFlutterPlugin = WireguardVpn();
  bool vpnActivate = false;
  Stats stats = Stats(totalDownload: 0, totalUpload: 0);
  String initName = 'sakec-wire4';
  String initAddress = "192.168.69.4/24";
  String initPort = "51820";
  String initDnsServer = "101.53.147.30";
  String initPrivateKey = "CDi9IdHiYJmw9mCzgBb3EIoUR8JNINnbdsMz0gYz1lE=";
  String initAllowedIp = "0.0.0.0/0, ::/0";
  String initPublicKey = "FytzEla1nQkpfGAouJaM1eFKR1e5N9vbt24of2+iIHg=";
  String initEndpoint = "115.113.39.74:51820";
  String presharedKey = "iP4F07mNzTur0nJc71T/rDxaJpIOk+Ntg8xyJafW1AY=";

  // Define variables to store cumulative upload and download data
  num cumulativeUpload = 0;
  num cumulativeDownload = 0;


  static Future<Map<String, dynamic>> getWireGuardConfig() async {
    const apiUrl = 'http://115.113.39.74:65528/api/user/wireguardapi';
    print('getwireconfig \n 46');
    // Device info
    var device = DeviceInfoPlugin();
    var os = "", mod = "";
    if (Platform.isAndroid) {
      print('51-android');
      var androidInfo = await device.androidInfo;
      os = "android";
      mod = androidInfo.model;
      print('54 - mod $mod');
    } else if (Platform.isIOS) {
      var iosInfo = await device.iosInfo;
      os = "ios";
      mod = iosInfo.model;
    }

    // IP address
    final response = await http.get(Uri.parse('https://api.ipify.org'));
    var ip = "";
    if (response.statusCode == 200) {
      ip = response.body;
    } else {
      throw Exception('Failed to get IP address');
    }
    print('Ip -  $ip');
    
    try {
      // final response = await http.post(Uri.parse(apiUrl));
      final token = await TokenManager.getToken(); print('73 - token - $token');
      final userDetails = await LocalStorage.getUserDetails(); print('74 - userDetails - $userDetails');
      final uid = userDetails['uid']; print('75 - uid - $uid');
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          "uid1": uid,
          "userip1": ip,
          "token1": token,
          "device1": os,
        }), // Include the IP address in the request body
        headers: {
          'Content-Type': 'application/json'
        }, // Specify the content type as JSON
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Success Api ');
        print('92 - responseData');
        print(responseData.toString());
        if (responseData['success'] == true) {
          return responseData['config1'];
        } else {
          throw Exception('API response indicates failure');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error'); 
    }
  }

  late String uid = '';
  late String displayName = '';

  @override
  void initState() {
    super.initState();
    vpnActivate ? _obtainStats() : null;
    getWireGuardConfig().then((config) {
      updateConfigValues(config);
      print('Inside update');
    });
    // Initialize the user with sample data or load it from storage
    _getUserDetails();
    // user = UserData(
    //   email: "admin@gmail.com",
    //   displayName: "Admin",
    // );
  }

  Future<void> _getUserDetails() async {
    try {print('134 - inside get user details');
      // Call the getUserDetails function from the LocalStorage class
      Map<String, String?> userDetails = await LocalStorage.getUserDetails();print('136 userdeatsils - $userDetails');
      setState(() {
        // Update the state variables with the retrieved values
        uid = userDetails['uid'] ?? '';
        displayName = userDetails['displayName'] ?? '';
      });
    } catch (error) {
      print('Error retrieving user details: $error');
    }
  }

  void updateConfigValues(Map<String, dynamic> config) {
    setState(() {
      print('Inside set state');
      initName = config['wgInterface']['name'];
      initAddress = config['wgInterface']['address'][0];
      initPort = config['peers'][0]['endpoint'].split(':')[1];
      initDnsServer = config['wgInterface']['dns'][0];
      initPrivateKey = config['wgInterface']['privateKey'];
      initAllowedIp = config['peers'][0]['allowedIps'][0];
      initPublicKey = config['peers'][0]['publicKey'];
      initEndpoint = config['peers'][0]['endpoint'];
      presharedKey = config['preSharedKey'];
      print(initName);
    });
  }

  /// The `_startTimerStream` function creates a stream that emits the current timer duration every
  /// second.
  ///
  /// Returns:
  ///   The timer duration is being returned.
  ///
  ///

  Future<void> vpnStats(num cumulativeDownload, num cumulativeUpload) async {
    String url = 'http://115.113.39.74:65528/api/user/vpnstat';

    String? token = await TokenManager.getToken();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "uid": uid,
          'token': token,
          'cumulativeDownload': cumulativeDownload,
          'cumulativeUpload': cumulativeUpload,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        print("api working propper vpn stats");
        // Fluttertoast.showToast(msg: 'Message Sent');
      } else {
        print("Failed to add contact: ${response.body}");
        // Fluttertoast.showToast(msg: 'Failed to send message');
      }
    } catch (error) {
      print("Failed to add contact: $error");
      //Fluttertoast.showToast(msg: 'Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vpnState = Provider.of<VpnState>(context, listen: true);
    final size = MediaQuery.of(context).size;
    // final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(60),
          ),
        ),
        toolbarHeight: 180,
        backgroundColor: const Color.fromARGB(255, 6, 111, 173),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello $displayName",
              style: const TextStyle(color: Colors.white, fontSize: 35),
            ),
            const Text(
              "Welcome to CyberPeace Secure DNS",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Text(
            'Active VPN: ${stats.totalDownload} Download - ${stats.totalUpload} Upload',
            style: const TextStyle(
              color: Color.fromARGB(255, 6, 111, 173),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(size.height),
                    onTap: () {
                      setState(() {
                        vpnState.toggleConnection();
                        if (vpnState.isConnected) {
                          vpnState.startTimer();
                          _activateVpn(vpnState.isConnected, vpnState);
                        } else {
                          vpnState.stopTimer();
                          _activateVpn(vpnState.isConnected, vpnState);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 6, 111, 173)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 6, 111, 173)
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: size.height * 0.20,
                          height: size.height * 0.20,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 6, 111, 173),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.power_settings_new,
                                    size: size.height * 0.08,
                                    color: Colors.white),
                                Text(
                                  vpnState.isConnected
                                      ? 'Disconnect'
                                      : 'Tap to Connect',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.height * 0.03,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        height: size.height * 0.080,
                        decoration: BoxDecoration(
                          color: vpnState.isConnected == false
                              ? const Color.fromARGB(255, 6, 111, 173)
                              : Colors.green.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          vpnState.isConnected == true
                              ? "Connected to CyberPeace Secure DNS"
                              : "Disconnected from CyberPeace Secure DNS",
                          style: TextStyle(
                              fontSize: size.height * 0.015,
                              color: vpnState.isConnected == true
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: const Color.fromARGB(255, 6, 111, 173),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
        ),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => parameters_logic(),
            ),
          ),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  /// The `_obtainStats` function periodically retrieves statistics from a WireGuard tunnel and updates
  /// the state with the results.
  void _obtainStats() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final results = await _wireguardFlutterPlugin.tunnelGetStats(initName);
      setState(() {
        stats = results ?? Stats(totalDownload: 0, totalUpload: 0);
        // Update cumulative upload and download data only when VPN is active
        if (vpnActivate) {
          cumulativeUpload = stats.totalUpload;
          cumulativeDownload = stats.totalDownload;

          // Call _sendDataToFirestore with updated cumulative values
          vpnStats(cumulativeDownload, cumulativeUpload);
        }
      });
    });
  }

  /// The `_activateVpn` function activates or deactivates a VPN, shows a toast message, updates the VPN
  /// state, and starts or stops a timer based on the VPN connection status.
  ///
  /// Args:
  ///   value (bool): A boolean value indicating whether the VPN should be activated or deactivated.
  ///   vpnState (VpnState): The `vpnState` parameter is an instance of the `VpnState` class. It is used
  /// to manage the state of the VPN connection, including whether it is connected or not, and to start
  /// and stop a timer associated with the VPN connection.
  void _activateVpn(bool value, VpnState vpnState) async {
    final toastMsg = value
        ? 'You are now connected to CyberPeace Secure DNS'
        : 'You are now disconnected to CyberPeace Secure DNS';
    final toastColor = value ? Colors.greenAccent : Colors.redAccent.shade100;

    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor,
      textColor: const Color.fromARGB(255, 6, 111, 173),
      fontSize: 16.0,
    );

    setState(() {
      vpnActivate = value;
      if (vpnActivate) {
        _obtainStats();
        if (vpnState.isConnected) {
          vpnState.startTimer();
          // _sendDataToFirestore(); // Call _sendDataToFirestore when VPN is connected
        }
      } else {
        vpnState.stopTimer();
      }
    });

    _activateVpnBackground(vpnState);
  }

  // Future<void> _sendDataToFirestore(
  //     num cumulativeUpload, num cumulativeDownload) async {
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // Get the token asynchronously
  //     String? token = await TokenManager.getToken();

  //     // Check if a document exists for the current user's UID
  //     final userDoc = firestore.collection('vpn_stats').doc();
  //     final userDocSnapshot = await userDoc.get();

  //     if (userDocSnapshot.exists) {
  //       // If the document exists, update it with new data
  //       await userDoc.update({
  //         'timestamp': Timestamp.now(),
  //         'token': token,
  //         'totaldownload': cumulativeDownload,
  //         'totalupload': cumulativeUpload,
  //       });
  //       print('Document updated successfully in Firestore');
  //     } else {
  //       // If the document does not exist, create a new one
  //       await userDoc.set({
  //         'timestamp': Timestamp.now(),
  //         'token': token,
  //         'totaldownload': cumulativeDownload,
  //         'totalupload': cumulativeUpload,
  //         'uid': uid,
  //       });
  //       print('Document created successfully in Firestore');
  //     }
  //   } catch (e) {
  //     print('Error adding/updating data to Firestore: $e');
  //   }
  // }

  /// The `_activateVpnBackground` function activates a VPN connection using the WireGuard Flutter plugin
  /// and updates the VPN connection state.
  ///
  /// Args:
  ///   vpnState (VpnState): The `vpnState` parameter is an instance of the `VpnState` class. It is used
  /// to manage the state of the VPN connection. The `connect()` method is called on the `vpnState`
  /// object to update the VPN connection state to connected, and the `disconnect()` method is
  void _activateVpnBackground(VpnState vpnState) async {
    final results =
        await _wireguardFlutterPlugin.changeStateParams(SetStateParams(
      state: vpnActivate,
      tunnel: Tunnel(
        name: initName,
        address: initAddress,
        dnsServer: initDnsServer,
        listenPort: initPort,
        peerAllowedIp: initAllowedIp,
        peerEndpoint: initEndpoint,
        peerPublicKey: initPublicKey,
        privateKey: initPrivateKey,
        peerPresharedKey: presharedKey,
      ),
    ));

    setState(() {
      if (results ?? false) {
        vpnState.connect(); // Update VPN connection state
        // Reset when connection is activated
        cumulativeUpload = 0;
        cumulativeDownload = 0;
      } else {
        vpnState.disconnect(); // Update VPN connection state
        // Reset when connection is deactivated
        cumulativeUpload = 0;
        cumulativeDownload = 0;
      }
    });
  }
}
