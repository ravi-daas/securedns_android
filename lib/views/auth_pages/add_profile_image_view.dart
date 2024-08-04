// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../controllers/UserController.dart';
import '../../entities/ProfileImage.dart';
import '../../views/widgets/outlined_button_with_image.dart';
import '../../views/widgets/round_edge_filled_button.dart';
import '../../constants/strings.dart';
import '../../models/User.dart';
import '../../models/user/UserHandlerModel.dart';
import '../../utils/show_error_view.dart';

class AddProfileImageView extends StatefulWidget {
  const AddProfileImageView({Key? key}) : super(key: key);

  @override
  State<AddProfileImageView> createState() => _AddProfileImageViewState();
}

class _AddProfileImageViewState extends State<AddProfileImageView> {
  String profileImageURL = defaultProfileImageURL;
  File? profileImageFile;
  bool isNetworkImage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              setProfileImageHeading,
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isNetworkImage
                  ? Image.asset(
                      profileImageURL,
                      width: 200,
                      height: 200,
                    )
                  : Image.file(
                      profileImageFile!,
                      width: 200,
                      height: 200,
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomOutlineButton(
                    buttonText: selectFromGalleryText,
                    onPressed: () async {
                      // Get the image from Camera
                      String? imagePath = await UserController()
                          .selectProfileImage(captureFromCamera: false);
                      if (mounted) {
                        if (imagePath != null) {
                          setState(() {
                            profileImageFile = File(imagePath);
                            isNetworkImage = false;
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomOutlineButton(
                    buttonText: selectFromCameraText,
                    onPressed: () async {
                      // Get the image from Camera
                      String? imagePath = await UserController()
                          .selectProfileImage(captureFromCamera: true);
                      if (mounted) {
                        if (imagePath != null) {
                          setState(() {
                            profileImageFile = File(imagePath);
                            isNetworkImage = false;
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            RoundEdgeFilledButton(
              buttonText: finaliseImageText,
              onPressed: () async {
                try {
                  if (profileImageFile != null) {
                    final userID =
                        Provider.of<UserData?>(context, listen: false)?.uid ??
                            "12345";

                    // String? newProfileImageUrl = await UserController()
                    //     .uploadImageToFirebaseStorage(
                    //         fileName: userID, file: profileImageFile!);

                    // UserData? updatedUser = await UserController()
                    //     .updateUserProfile(photoURL: newProfileImageUrl);

                    // await UserHandlerModel().updateSingleUserDetail(context,
                    //     key: 'photoUrl', value: newProfileImageUrl);

                    // if (updatedUser?.photoUrl != null) {
                    //   if (mounted) {
                    //     Provider.of<ProfileImage?>(context, listen: false)
                    //         ?.setProfileImage(newProfileImageUrl);

                    //     Navigator.pushNamed(context, "/");
                    //   }
                    // }
                  }
                } catch (e) {
                  debugPrint(
                      "Failed to update user details to database: ${e.toString()}");
                  showBottomNotificationMessage(
                    context,
                    "Oops! Something went wrong! Please try again.",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
