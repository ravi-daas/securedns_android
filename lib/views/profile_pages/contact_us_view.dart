import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../widgets/authbutton_widget_view.dart';
import '../widgets/input_with_icon.dart';
import 'package:http/http.dart' as http;

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key, required this.data}) : super(key: key);
  final Map<dynamic, dynamic>? data;

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  CollectionReference contactUs =
      FirebaseFirestore.instance.collection("ContactUs");

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      nameController.text = widget.data!['name'] ?? '';
      emailController.text = widget.data!['email'] ?? '';
    }
  }

  // void addContactUs() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     contactUs.doc(emailController.text).set({
  //       "name": nameController.text.trim(),
  //       "email": emailController.text.trim(),
  //       "message": messageController.text.trim(),
  //     }).then((_) {
  //       Fluttertoast.showToast(msg: 'Message Sent');
  //       setState(() {
  //         nameController.clear();
  //         messageController.clear();
  //         emailController.clear();
  //       });
  //     }).catchError((error) {
  //       print("Failed to add contact: $error");
  //       Fluttertoast.showToast(msg: 'Failed to send message');
  //     });
  //   }
  // }

  Future<void> contactApi() async {
    String url = 'http://115.113.39.74:65528/api/user/contact';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": emailController.text.trim(),
          "message": messageController.text.trim(),
          "name": nameController.text.trim(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        print("api working propper contact");
        Fluttertoast.showToast(msg: 'Message Sent');
      } else {
        print("Failed to add contact: ${response.body}");
        Fluttertoast.showToast(msg: 'Failed to send message');
      }
    } catch (error) {
      print("Failed to add contact: $error");
      Fluttertoast.showToast(msg: 'Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(color: white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  InputWithIcon(
                    btnIcon: Icons.account_circle_rounded,
                    hintText: nameHintText,
                    myController: nameController,
                    keyboardType: TextInputType.name,
                    validateFunc: (val) {
                      if (val!.isEmpty) {
                        return nameEmptyWarning;
                      }
                      return null;
                    },
                    obscure: false,
                  ),
                  const SizedBox(height: 20),
                  InputWithIcon(
                    btnIcon: Icons.email,
                    hintText: 'Email',
                    myController: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validateFunc: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    obscure: false,
                  ),
                  const SizedBox(height: 20),
                  InputWithIcon(
                    btnIcon: Icons.message,
                    hintText: 'Enter your message',
                    myController: messageController,
                    keyboardType: TextInputType.text,
                    validateFunc: (value) {
                      if (value!.isEmpty) {
                        return "Message is required";
                      }
                      return null;
                    },
                    obscure: false,
                  ),
                  const SizedBox(height: 30),
                  AuthButtonWidget(
                    btnTxt: 'Send Message',
                    onPress: () {
                      contactApi();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
