import 'dart:io';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../consts/login_sliders.dart';
import '../../../imports.dart';
import '../../screens/log_in/log_in_screen.dart';
import '../../widgets/login_button.dart';
import '../../widgets/text_input.dart';
import 'sign_up_controller.dart';

class FxSignUpScreen extends ScreenMaster<FxSignUpController> {
  final _formKey = GlobalKey<FormBuilderState>();

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
                          Trns.signInWithApple.val,
                          icon: const Icon(
                            FontAwesomeIcons.apple,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onClick: () {
                            controller.signInWithApple();
                          },
                        ),
                      SizedBox(height: 4.h),
                      const Text("OR"),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              heightFactor: 2,
                              child: Text(
                                Trns.signUp.val,
                                style:
                                    Theme.of(Get.context!).textTheme.headline6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Theme(
                          data: ThemeData().copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: Util.to.getConfig("primary_color"),
                                  secondary:
                                      Util.to.getConfig("accent_color"))),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(children: [
                              TextInput(
                                  name: 'name',
                                  label: Trns.name.val,
                                  icon: Icons.person_outline,
                                  obscureText: false,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        Get.context!),
                                    FormBuilderValidators.maxLength(
                                        Get.context!, 50),
                                  ])),
                              TextInput(
                                  name: 'email',
                                  label: Trns.email.val,
                                  icon: Icons.email_outlined,
                                  obscureText: false,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        Get.context!),
                                    FormBuilderValidators.email(Get.context!),
                                    FormBuilderValidators.maxLength(
                                        Get.context!, 50),
                                  ])),
                              TextInput(
                                  name: 'password',
                                  label: Trns.password.val,
                                  icon: Icons.vpn_key,
                                  obscureText: true,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        Get.context!),
                                    FormBuilderValidators.maxLength(
                                        Get.context!, 50),
                                    FormBuilderValidators.minLength(
                                        Get.context!, 8),
                                  ])),
                              TextInput(
                                  name: 'confirm_password',
                                  label: Trns.confirmPassword.val,
                                  icon: Icons.vpn_key,
                                  obscureText: true,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                        Get.context!),
                                    FormBuilderValidators.maxLength(
                                        Get.context!, 50),
                                    FormBuilderValidators.minLength(
                                        Get.context!, 8),
                                    (val) {
                                      if (_formKey.currentState!
                                              .fields['password']?.value !=
                                          val) {
                                        return Trns
                                            .warningPasswordsNotMatching.val;
                                      }
                                      return null;
                                    }
                                  ])),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 75.w,
                                height: 48,
                                child: ElevatedButton(
                                  child: Text(Trns.signUp.val),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      var name = _formKey
                                          .currentState!.fields['name']?.value;
                                      var email = _formKey
                                          .currentState!.fields['email']?.value;
                                      var password = _formKey.currentState!
                                          .fields['password']?.value;
                                      controller.signUpWithEmailAndPassword(
                                          email, password, name);
                                    } else {
                                      Util.to.logger().e("Validation Failed");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(Trns.alreadyHaveAnAccount.val),
                                  InkWell(
                                      child: Text(
                                        Trns.signIn.val,
                                        style: TextStyle(
                                            color: Util.to
                                                .getConfig("primary_color"),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        Get.off(() =>
                                            FxLoginScreen(LoginSliders.login));
                                      }),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ));
  }
}
