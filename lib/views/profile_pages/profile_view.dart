/*

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygiene_ui/constants/colors.dart';
import 'package:cygiene_ui/models/authentication/AuthServiceModel.dart';
import 'package:cygiene_ui/views/profile_pages/faqs_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';
import '../../providers/vpn_provider.dart';
import '../widgets/custom_dialog_widget_view.dart';
import 'about_us_view.dart';
// import 'edit_profile_view.dart';
import 'contact_us_view.dart';
import 'package:cygiene_ui/utils/token_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserData?>(context);
    final Stream<QuerySnapshot<Map<String, dynamic>>> _userStream =
        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user?.email)
            .snapshots(includeMetadataChanges: true);
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 6, 111, 173),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Account",
            style: TextStyle(
              color: Color(
                0xFF1B0938,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map>>(
            stream: _userStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return ListView(
                // body: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(40),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 6, 111, 173),
                            size: 100,
                          )),
                    ),
                  ),


                  // const Padding(
                  //   padding: EdgeInsets.only(bottom: 20),
                  // ),
                  // GestureDetector(
                  //   child: Card(
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       side: const BorderSide(color: Colors.white),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: ListTile(
                  //       onTap: (() => {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => const EditProfileView(
                  //                   // data: snapshot.data,
                  //                   data: null,
                  //                 ),
                  //               ),
                  //             ),
                  //           }),
                  //       title: const Text(
                  //         'Edit profile',
                  //         style: TextStyle(
                  //             color: Color.fromARGB(255, 6, 111, 173),
                  //             fontSize: 22,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       leading: const Icon(
                  //         Icons.edit,
                  //         color: Color.fromARGB(255, 6, 111, 173),
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ),
                  // ),



                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactUsView(
                                  data: snapshot.data?.docs.first.data(),
                                ),
                              ),
                            ),
                          }),
                      title: const Text(
                        'Contact us',
                        style: TextStyle(
                            color: Color.fromARGB(255, 6, 111, 173),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(
                        Icons.contact_phone,
                        color: Color.fromARGB(255, 6, 111, 173),
                      ),
                      // tileColor: Color.fromARGB(255, 60, 7, 74),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUsView(),
                              ),
                            ),
                          }),
                      title: const Text(
                        'About us',
                        style: TextStyle(
                            color: Color.fromARGB(255, 6, 111, 173),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(
                        Icons.perm_device_information,
                        color: Color.fromARGB(255, 6, 111, 173),
                        size: 30,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const faqs_view(),
                              ),
                            ),
                          }),
                      title: const Text(
                        'Faqs',
                        style: TextStyle(
                            color: Color.fromARGB(255, 6, 111, 173),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(
                        Icons.question_answer,
                        color: Color.fromARGB(255, 6, 111, 173),
                        size: 30,
                      ),
                      // tileColor: Color.fromARGB(255, 60, 7, 74),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: CustomConfirmDialog(
                            title: "Logout",
                            subtitle: "Are you sure you want to?",
                            icon: const Icon(
                              Icons.logout,
                              color: white,
                              size: 70,
                            ),
                            onYesPressed: () {
                              setState(() {
                                VpnState vpnState = context.read<VpnState>();
                                vpnState.disconnect();
                                TokenManager.deleteToken().then((_) {
                                  AuthServiceModel()
                                      .signOutUser()
                                      .then((value) => {
                                            AndroidAlarmManager.cancel(0)
                                                .then((value) => {
                                                      // Reset the VPN state provider to initial state
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              '/login',
                                                              (route) =>
                                                                  false) // Remove all routes from the stack
                                                    })
                                          });
                                });
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 1, 61, 84),
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const ListTile(
                        title: Text(
                          'Log Out',
                          style: TextStyle(
                              color: Color.fromARGB(255, 6, 111, 173),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 6, 111, 173),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}

*/

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cygiene_ui/constants/colors.dart';
import 'package:cygiene_ui/models/authentication/AuthServiceModel.dart';
import 'package:cygiene_ui/views/profile_pages/faqs_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/User.dart';
import '../../providers/vpn_provider.dart';
import '../widgets/custom_dialog_widget_view.dart';
import 'about_us_view.dart';
import 'contact_us_view.dart';
import 'package:cygiene_ui/utils/token_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserData?>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 111, 173),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Account",
          style: TextStyle(
            color: Color(0xFF1B0938),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(40),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 6, 111, 173),
                  size: 100,
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsView(data: null),
                  ),
                );
              },
              title: const Text(
                'Contact us',
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 111, 173),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(
                Icons.contact_phone,
                color: Color.fromARGB(255, 6, 111, 173),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsView(),
                  ),
                );
              },
              title: const Text(
                'About us',
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 111, 173),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(
                Icons.perm_device_information,
                color: Color.fromARGB(255, 6, 111, 173),
                size: 30,
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const faqs_view(),
                  ),
                );
              },
              title: const Text(
                'Faqs',
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 111, 173),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(
                Icons.question_answer,
                color: Color.fromARGB(255, 6, 111, 173),
                size: 30,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: CustomConfirmDialog(
                    title: "Logout",
                    subtitle: "Are you sure you want to?",
                    icon: const Icon(
                      Icons.logout,
                      color: white,
                      size: 70,
                    ),
                    onYesPressed: () {
                      setState(() {
                        VpnState vpnState = context.read<VpnState>();
                        vpnState.disconnect();
                        TokenManager.deleteToken().then((_) {
                          AuthServiceModel().signOutUser().then((value) {
                            AndroidAlarmManager.cancel(0).then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            });
                          });
                        });
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromARGB(255, 1, 61, 84),
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const ListTile(
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 111, 173),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 6, 111, 173),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
