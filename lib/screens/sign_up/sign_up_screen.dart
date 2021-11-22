import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexus_framework/screens/log_in/sliders/forgot_password_slider.dart';
import 'package:flexus_framework/screens/log_in/sliders/sign_up_slider.dart';
import 'package:flexus_framework/screens/log_in/sliders/verify_email_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../imports.dart';
import '../../widgets/login_button.dart';
import 'sign_up_controller.dart';

class FxSignUpScreen extends ScreenMaster<FxSignUpController> {
  final int? initialPage;
  const FxSignUpScreen(this.initialPage, {Key? key}) : super(key: key);

  @override
  Widget create() {
    return ScaffoldMaster(Trns.signUp.val,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        body: Obx(
          () => LoadingOverlay(
            opacity: 0.0,
            isLoading: controller.isLoading.value,
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginButton(
                        Trns.signUpWithGoogle.val,
                        icon: const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                          size: 24.0,
                        ),
                        onClick: () {
                          controller.signInWithGoogle();
                        },
                      ),
                      LoginButton(
                        Trns.signUpWithFacebook.val,
                        icon: const Icon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        onClick: () {
                          controller.signInWithFacebook();
                        },
                      ),
                      if (Platform.isIOS)
                        LoginButton(
                          Trns.signUpWithApple.val,
                          icon: const Icon(
                            FontAwesomeIcons.apple,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onClick: () {
                            controller.signInWithApple();
                          },
                        ),
                      SizedBox(height: 1.h),
                      const Text("OR"),
                    ],
                  ),
                ),
                CarouselSlider(
                  carouselController: controller.loginSliderController,
                  options: CarouselOptions(
                      height: 65.h,
                      viewportFraction: 1,
                      initialPage: initialPage!,
                      scrollPhysics: const NeverScrollableScrollPhysics()),
                  items: [
                    FxSignUpSlider(),
                    FxVerifyEmailSlider(),
                    FxForgotPasswordSlider()
                  ],
                )
              ]),
            ),
          ),
        ));
  }
}
