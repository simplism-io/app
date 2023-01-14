import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/icons/email_icon.dart';
import '../../services/agent_service.dart';
import '../../services/localization_service.dart';
import '../../constants/links/go_back_link.dart';
import '../root.dart';
import 'profile_screen.dart';

final supabase = Supabase.instance.client;

class UpdateProfileScreen extends StatefulWidget {
  final dynamic agent;
  final Uint8List? avatarBytes;
  const UpdateProfileScreen({Key? key, this.agent, this.avatarBytes})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();
  bool loader = false;

  String? name;
  String? email;

  dynamic tempFile;
  XFile? avatarFile;
  Uint8List? avatar;

  dynamic avatarAsBytes;
  String? base64Avatar;
  Uint8List? avatarBytes;
  final ImagePicker _picker = ImagePicker();

  Future pickAvatar(camera) async {
    Navigator.pop(context);
    avatarFile = await _picker.pickImage(
        source: camera == true ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640);
    if (avatarFile != null) {
      setState(() => {loader = true});
    }
    avatarAsBytes = await avatarFile!.readAsBytes();
    base64Avatar = base64Encode(avatarAsBytes);
    setState(() => {loader = false, avatarBytes = base64Decode(base64Avatar!)});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      setState(() => loader = true);
      final response =
          await AgentService().updateProfileProcedure(name, email, avatar);
      if (response == true) {
        final newProfile = await AgentService().loadAgent();
        if (!mounted) return;
        // SnackBarService()
        //     .successSnackBar('update_profile_snackbar_label', context);
        if (EmailValidator.validate(newProfile!.email)) {
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(agent: newProfile)),
              (route) => false);
        } else {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Root()),
              (route) => false);
        }
      } else {
        setState(() {
          loader = false;
        });
        if (!mounted) return;
        setState(() => {loader = false});
        // SnackBarService()
        //     .errorSnackBar('authentication_error_snackbar_label', context);
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: ResponsiveVisibility(
            visible: false,
            visibleWhen: const [Condition.smallerThan(name: TABLET)],
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 450.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 450.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                  LocalizationService.of(context)?.translate(
                                          'update_profile_header_label') ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 30.0),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 200.0,
                                    child: avatarBytes != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.memory(avatarBytes!))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.memory(
                                                widget.avatarBytes!)),
                                  ),
                                  const SizedBox(height: 20),
                                  TextButton(
                                      onPressed: () => {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: SimpleDialog(
                                                    title: Center(
                                                        child: Text(kIsWeb
                                                            ? LocalizationService.of(
                                                                        context)
                                                                    ?.translate(
                                                                        'select_avatar_label') ??
                                                                ''
                                                            : LocalizationService.of(
                                                                        context)
                                                                    ?.translate(
                                                                        'make_select_avatar_label') ??
                                                                '')),
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          kIsWeb
                                                              ? Container()
                                                              : IconButton(
                                                                  icon:
                                                                      const Icon(
                                                                    FontAwesomeIcons
                                                                        .cameraRetro,
                                                                    size: 20.0,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await pickAvatar(
                                                                        true);
                                                                  },
                                                                ),
                                                          const Spacer(),
                                                          IconButton(
                                                            icon: const Icon(
                                                              FontAwesomeIcons
                                                                  .image,
                                                              size: 20.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await pickAvatar(
                                                                  false);
                                                            },
                                                          ),
                                                          const Spacer()
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          },
                                      child: Text(
                                          LocalizationService.of(context)
                                                  ?.translate(
                                                      'change_avatar_button_label') ??
                                              '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)))
                                ],
                              ),
                              const SizedBox(height: 50.0),
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 300.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 300.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'email_input_hinttext') ??
                                            '',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        labelText:
                                            LocalizationService.of(context)
                                                    ?.translate(
                                                        'email_input_label') ??
                                                '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const EmailIcon()),
                                    textAlign: TextAlign.left,
                                    initialValue: widget.agent["email"],
                                    autofocus: true,
                                    validator: (String? value) {
                                      return !EmailValidator.validate(value!)
                                          ? 'Please provide a valid email.'
                                          : null;
                                    },
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    }),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    labelText: LocalizationService.of(context)
                                            ?.translate('name_input_label') ??
                                        '',
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                    ), //label style
                                    prefixIcon: Icon(
                                        (defaultTargetPlatform ==
                                                    TargetPlatform.iOS ||
                                                defaultTargetPlatform ==
                                                    TargetPlatform.macOS)
                                            ? CupertinoIcons.smiley
                                            : FontAwesomeIcons.faceLaugh,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                    hintText: LocalizationService.of(context)
                                            ?.translate('name_input_label') ??
                                        '',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                  initialValue: widget.agent["name"],
                                  autofocus: true,
                                  validator: (String? value) {
                                    //print(value.length);
                                    return (value != null && value.length < 2)
                                        ? LocalizationService.of(context)
                                                ?.translate(
                                                    'invalid_name_message') ??
                                            ''
                                        : null;
                                  },
                                  onChanged: (val) {
                                    setState(() => name = val);
                                  }),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 300.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 300.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: (defaultTargetPlatform ==
                                            TargetPlatform.iOS ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.macOS)
                                    ? CupertinoButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            submit();
                                          } else {
                                            setState(() {
                                              loader = false;
                                            });
                                          }
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            loader == true
                                                ? LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'loader_button_label') ??
                                                    ''
                                                : LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'update_profile_button_label') ??
                                                    '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            submit();
                                          } else {
                                            setState(() {
                                              loader = false;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            loader == true
                                                ? LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'loader_button_label') ??
                                                    ''
                                                : LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'update_profile_button_label') ??
                                                    '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              )
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GoBackLink(
                      removeState: false,
                      label: LocalizationService.of(context)
                              ?.translate('go_back_profile_link_label') ??
                          ''),
                ],
              ),
            ),
          ),
        ));
  }
}
