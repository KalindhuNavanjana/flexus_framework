// Copyright 2021 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../consts/login_sliders.dart';
import '../../flexus_framework.dart';
import '../../imports.dart';
import '../../services/auth_service.dart';

class FxLogInController extends GetxController {
  var isLoading = false.obs;
  final CarouselController loginSliderController = CarouselController();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      Util.to.logger().i("Use sign in was successful with email");
      Util.to.logger().i(user);
      if (user != null) {
        Util.to.setAuthUserDetails(AuthService.to.authUser.value, user);
        if (user.emailVerified) {
          AuthService.to.isEmailVerified.value = true;
          isLoading.value = false;
          AuthService.to
              .afterLogin()
              .then((value) => Get.offAll(() => Util.to.getHomeScreen()));
        } else {
          await user.sendEmailVerification();
          isLoading.value = false;
          loginSliderController.jumpToPage(LoginSliders.verify_email);
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Util.to.handleSignError(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
          FlexusController.to.title.value, Trns.error_sign_up_failure.val,
          snackPosition: SnackPosition.BOTTOM);
      Util.to.logger().e(e);
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        Util.to.setAuthUserDetails(AuthService.to.authUser.value, user);
        isLoading.value = false;
        AuthService.to
            .afterLogin()
            .then((value) => Get.offAll(() => Util.to.getHomeScreen()));
      }
    } catch (e) {
      Util.to.logger().e(e);
      isLoading.value = false;
      Get.snackbar(
          FlexusController.to.title.value, Trns.error_google_sign_in_failed.val,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithFacebook() async {
    isLoading.value = true;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          AuthCredential credential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          User? user =
              (await FirebaseAuth.instance.signInWithCredential(credential))
                  .user;
          Util.to.logger().i(user);
          if (user != null) {
            Util.to.setAuthUserDetails(AuthService.to.authUser.value, user);
            isLoading.value = false;
            if (user.emailVerified) {
              AuthService.to.isEmailVerified.value = true;
              AuthService.to
                  .afterLogin()
                  .then((value) => Get.offAll(() => Util.to.getHomeScreen()));
            } else {
              await user.sendEmailVerification();
              loginSliderController.jumpToPage(LoginSliders.verify_email);
            }
          }
          break;
        case LoginStatus.cancelled:
          Util.to.logger().e(result.message);
          isLoading.value = false;
          Get.snackbar(FlexusController.to.title.value,
              Trns.error_facebook_sign_in_canceled.val,
              snackPosition: SnackPosition.BOTTOM);
          break;
        case LoginStatus.failed:
          Util.to.logger().e(result.message);
          isLoading.value = false;
          Get.snackbar(FlexusController.to.title.value,
              Trns.error_facebook_sign_in_failed.val,
              snackPosition: SnackPosition.BOTTOM);
          break;
        default:
      }
    } on FirebaseAuthException catch (e) {
      Util.to.handleSignError(e);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
          FlexusController.to.title.value, Trns.error_sign_up_failure.val,
          snackPosition: SnackPosition.BOTTOM);
      Util.to.logger().e(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
          FlexusController.to.title.value, Trns.reset_password_sent.val,
          snackPosition: SnackPosition.BOTTOM);
      loginSliderController.jumpToPage(LoginSliders.login);
    } catch (e) {
      Util.to.logger().e(e);
      Get.snackbar(
          FlexusController.to.title.value, Trns.error_reset_password_failed.val,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
