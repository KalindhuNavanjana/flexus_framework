// Copyright 2021 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license

import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../widgets/dialog_box_button.dart';
import 'flexus_framework.dart';
import 'imports.dart';
import 'models/auth_user.dart';

class Util extends GetxController {
  static Util get to => Get.find();

  final _logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));

  Logger logger() {
    return _logger;
  }

  getConfig(String configName) {
    return FlavorConfig.instance.variables[configName];
  }

  Widget getHomeScreen() {
    return Util.to.getConfig("homeScreen");
  }

  setAuthUserDetails(AuthUser authUser, User user) {
    authUser.uuid = user.uid;
    authUser.name = user.displayName;
    authUser.email = user.email;
    if (user.photoURL == null) {
      authUser.profilePicture = user.providerData[0].photoURL;
    } else {
      authUser.profilePicture = user.photoURL;
    }

    authUser.isEmailVerified = user.emailVerified;
    switch (user.providerData[0].providerId) {
      case 'facebook.com':
        authUser.authType = AuthType.facebook;
        break;
      case 'google.com':
        authUser.authType = AuthType.google;
        break;
      case 'apple.com':
        authUser.authType = AuthType.apple;
        break;
      default:
        authUser.authType = AuthType.email;
    }
  }

  String getInitials({required String string, required int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    if (limitTo > split.length) {
      limitTo = split.length;
    }
    for (var i = 0; i < limitTo; i++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }

  Widget getCircularAvatar(
      String? profilePicture, String? name, BuildContext? context,
      {File? imageFile}) {
    if (imageFile != null && imageFile.path != "") {
      return CircleAvatar(
          radius: 51,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            backgroundImage:
                NetworkToFileImage(url: profilePicture, file: imageFile),
            radius: 50,
            backgroundColor: Colors.white,
          ));
    } else if (profilePicture != null) {
      return CircleAvatar(
          radius: 51,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            backgroundImage: NetworkToFileImage(url: profilePicture),
            radius: 50,
            backgroundColor: Colors.white,
          ));
    } else {
      return CircleAvatar(
        radius: 51,
        backgroundColor: Colors.black,
        child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              Util.to.getInitials(string: name ?? "-", limitTo: 2),
              style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(Get.context!).colorScheme.primary),
            )),
      );
    }
  }

  void showErrorSnackBar(String title, String message) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
  }

  Map<String, Map<String, String>> getTranslations(
      Map<String, Map<String, String>> map1,
      Map<String, Map<String, String>> map2) {
    map1.forEach(
        (c, o) => map1[c]!.forEach((k, v) => map2[c]?.putIfAbsent(k, () => v)));
    return map2;
  }

  // Dialog Boxes

  void showOKDialog(
      {required String message,
      required String title,
      String? textOK,
      VoidCallback? onOKPressed,
      Widget? content,
      bool barrierDismissible = false}) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        barrierDismissible: barrierDismissible,
        content: content,
        confirm: DialogBoxButton(
            textOK ?? Trns.ok.val, onOKPressed ?? () => Get.back()),
        radius: 8);
  }

  void showYesNoDialog(
      {required String message,
      required String title,
      String? textYes,
      String? textNo,
      VoidCallback? onYesPressed,
      VoidCallback? onNoPressed,
      Widget? content,
      bool barrierDismissible = false}) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        content: content,
        barrierDismissible: barrierDismissible,
        confirm: DialogBoxButton(
            textYes ?? Trns.yes.val, onYesPressed ?? () => Get.back()),
        cancel: DialogBoxButton(
            textNo ?? Trns.no.val, onNoPressed ?? () => Get.back()),
        radius: 8);
  }

  void showYesNoCustomDialog(
      {required String message,
      required String title,
      String? textYes,
      String? textNo,
      String? textCustom,
      VoidCallback? onYesPressed,
      VoidCallback? onNoPressed,
      VoidCallback? onCustomPressed,
      Widget? content,
      bool barrierDismissible = false}) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        content: content,
        barrierDismissible: barrierDismissible,
        confirm: DialogBoxButton(
            textYes ?? Trns.yes.val, onYesPressed ?? () => Get.back()),
        cancel: DialogBoxButton(
            textNo ?? Trns.no.val, onNoPressed ?? () => Get.back()),
        custom: DialogBoxButton(
            textCustom ?? Trns.ok.val, onCustomPressed ?? () => Get.back()),
        radius: 8);
  }

  Future<File> getFile(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, filename);
    return File(pathName);
  }

  void handleSignError(FirebaseAuthException e) {
    switch (e.code) {
      case "user-not-found":
        Util.to.showErrorSnackBar(
            FlexusController.to.title.value, Trns.errorNoUserFound.val);
        break;
      case "wrong-password":
        Util.to.showErrorSnackBar(
            FlexusController.to.title.value, Trns.errorWrongPassword.val);
        break;
      case "weak-password":
        Util.to.showErrorSnackBar(
            FlexusController.to.title.value, Trns.errorWeakPassword.val);
        break;
      case "email-already-in-use":
        Util.to.showErrorSnackBar(
            FlexusController.to.title.value, Trns.errorAccountAlreadyExist.val);
        break;
      case "account-exists-with-different-credential":
        Util.to.showErrorSnackBar(FlexusController.to.title.value,
            Trns.errorAccountExistWithSameEmail.val);
        break;
      case "too-many-requests":
        Util.to.showErrorSnackBar(FlexusController.to.title.value,
            Trns.errorAccountExistWithSameEmail.val);
        break;
      default:
        Util.to.showErrorSnackBar(
            FlexusController.to.title.value, Trns.errorSignInFailure.val);
    }
  }

  dynamic getSizesForScreens({required dynamic mobile, dynamic tablet}) {
    tablet ??= mobile;
    switch (SizerUtil.deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      default:
        return mobile;
    }
  }

  String createNonce(int length) {
    final random = Random();
    final charCodes = List<int>.generate(length, (_) {
      int codeUnit = 0;

      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });

    return String.fromCharCodes(charCodes);
  }

  bool isDarkMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    // return brightness == Brightness.dark;
    return true;
  }
}
