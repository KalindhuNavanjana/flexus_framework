// Copyright 2021 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license

import 'dart:async';
import 'dart:io';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../imports.dart';
import '../../../models/auth_user.dart';
import '../../../widgets/form_field_separator.dart';
import '../../../widgets/text_datetime_picker.dart';
import '../../../widgets/text_dropdown.dart';
import '../../../widgets/text_input.dart';
import '../../flexus_framework.dart';
import '../../services/auth_service.dart';
import 'profile_controller.dart';

class FxProfileScreen extends ScreenMaster<FxProfileController> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FxProfileController profileController = Get.put(FxProfileController());
  final imagePicker = ImagePicker();

  @override
  Widget create() {
    return ScaffoldMaster(
      Trns.update_profile.val,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      body: Obx(
        () => LoadingOverlay(
          opacity: 0.0,
          isLoading: profileController.isLoading.value,
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: Util.to.getConfig("primary_color"),
                    accentColor: Util.to.getConfig("accent_color"),
                    hintColor: Util.to.getConfig("primary_color"),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        primary: Util.to.getConfig("primary_color"),
                      ),
                    ),
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(children: [
                      SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => Util.to.getCircularAvatar(
                                AuthService.to.authUser.value.profilePicture,
                                AuthService.to.authUser.value.name,
                                context,
                                imageFile: controller.imageFile.value),
                          ),
                          if (AuthService.to.authUser.value.authType ==
                              AuthType.email)
                            Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: ElevatedButton(
                                onPressed: _readPhoto,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Theme.of(Get.context!).primaryColor,
                                ),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(AuthService.to.authUser.value.email!,
                          style: TextStyle(color: Colors.black)),
                      SizedBox(height: 16),
                      /*
                        Account Section
                        */
                      FormFieldSeparator(Trns.account_details.val),
                      TextInput(
                          name: 'name',
                          label: Trns.name.val,
                          initialValue: AuthService.to.authUser.value.name,
                          icon: Icons.person_outline,
                          obscureText: false,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.maxLength(context, 50),
                          ])),
                      _getGenderTextField(context),
                      TextDateTimePicker(
                        name: 'date_of_birth',
                        label: Trns.date_of_birth.val,
                        inputType: InputType.date,
                        icon: Icons.date_range_outlined,
                        initialValue: AuthService.to.authUser.value.dateOfBirth,
                        enabled:
                            AuthService.to.authUser.value.dateOfBirth != null
                                ? false
                                : true,
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                      ),

                      /*
                        Security Section
                        */
                      FormFieldSeparator(Trns.security.val),
                      TextInput(
                          name: 'password',
                          label: Trns.password.val,
                          icon: Icons.vpn_key,
                          obscureText: true,
                          enabled: AuthService.to.authUser.value.authType ==
                              AuthType.email,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.maxLength(context, 50),
                            (val) {
                              if (val != null && val.length < 8) {
                                return Trns.warning_minimum_password_length.val;
                              }
                              return null;
                            }
                          ])),
                      TextInput(
                          name: 'confirm_password',
                          label: Trns.confirm_password.val,
                          icon: Icons.vpn_key,
                          enabled: AuthService.to.authUser.value.authType ==
                              AuthType.email,
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.maxLength(context, 50),
                            (val) {
                              if (_formKey.currentState!.fields['password']
                                      ?.value !=
                                  val) {
                                return Trns.warning_passwords_not_matching.val;
                              }
                              return null;
                            }
                          ])),
                      SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: Get.width, height: 48),
                        child: ElevatedButton(
                          child: Text(Trns.update_profile.val),
                          onPressed: () {
                            profileController.isLoading.value = true;
                            controller.updateProfile(_formKey);
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _getGenderTextField(BuildContext context) {
    Gender? gender = AuthService.to.authUser.value.gender;
    var name = "gender";
    var label = Trns.gender.val;
    var hint = Trns.select_the_gender.val;
    var icon = Icons.attribution_outlined;
    var items = ["male", "female"];
    var enabled = gender != null ? false : true;
    String? Function(dynamic) validator = FormBuilderValidators.compose(
        [FormBuilderValidators.required(context)]);
    if (gender != null) {
      return TextDropdown(
        name: name,
        label: label,
        hint: hint,
        icon: icon,
        initialValue: gender.toShortString(),
        items: items,
        enabled: enabled,
        validator: validator,
      );
    } else {
      return TextDropdown(
          name: name,
          label: label,
          hint: hint,
          icon: icon,
          items: items,
          enabled: enabled,
          validator: validator);
    }
  }

  Future _readPhoto() async {
    Util.to.showOKDialog(
        textOK: Trns.cancel.val,
        message: "",
        title: FlexusController.to.title.value,
        content: Column(
          children: [
            Text("Please select the source"),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 64, minHeight: 64),
                      child: ElevatedButton(
                        onPressed: () => _getImage(ImageSource.camera),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: Theme.of(Get.context!).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Camera")
                  ],
                ),
                SizedBox(width: 32),
                Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 64, minHeight: 64),
                      child: ElevatedButton(
                        onPressed: () => _getImage(ImageSource.gallery),
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                          size: 40,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: Theme.of(Get.context!).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Gallery")
                  ],
                )
              ],
            )
          ],
        ));
  }

  _getImage(ImageSource imageSource) async {
    Get.back();
    final pickedFile = await (imagePicker.pickImage(source: imageSource));
    File? croppedFile = await (ImageCropper.cropImage(
        sourcePath: pickedFile!.path,
        maxWidth: 512,
        maxHeight: 512,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )));
    controller.imageFile.value = File(croppedFile!.path);
  }
}
