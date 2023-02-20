import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../../services/view_service.dart';
import '../root.dart';

class CreateViewScreen extends StatefulWidget {
  const CreateViewScreen({super.key});

  @override
  State<CreateViewScreen> createState() => _CreateViewScreenState();
}

class _CreateViewScreenState extends State<CreateViewScreen> {
  final formKey = GlobalKey<FormState>();
  String? name;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      setState(() => loader = true);
      final result = await ViewService().createCustomView();
      if (result == true) {
        if (!mounted) return;
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('create_agent_name_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Root()),
            (route) => false);
      } else {
        setState(() {
          loader = false;
        });
        if (!mounted) return;
        setState(() => {loader = false});
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('general_error_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Column(
          children: [
            Center(
                child: SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 450.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 450.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                              LocalizationService.of(context)?.translate(
                                      'create_agent_name_header_label') ??
                                  '',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                          const SizedBox(height: 40.0),
                          SizedBox(
                            width: ResponsiveValue(context,
                                defaultValue: 360.0,
                                valueWhen: const [
                                  Condition.largerThan(
                                      name: MOBILE, value: 360.0),
                                  Condition.smallerThan(
                                      name: TABLET, value: double.infinity)
                                ]).value,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                          ),
                          const SizedBox(height: 15.0),
                          SizedBox(
                            width: ResponsiveValue(context,
                                defaultValue: 360.0,
                                valueWhen: const [
                                  Condition.largerThan(
                                      name: MOBILE, value: 360.0),
                                  Condition.smallerThan(
                                      name: TABLET, value: double.infinity)
                                ]).value,
                            child: (defaultTargetPlatform ==
                                        TargetPlatform.iOS ||
                                    defaultTargetPlatform ==
                                        TargetPlatform.macOS)
                                ? CupertinoButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        submit();
                                      } else {
                                        setState(() {
                                          loader = false;
                                        });
                                      }
                                    },
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      loader == true
                                          ? LocalizationService.of(context)
                                                  ?.translate(
                                                      'loader_button_label') ??
                                              ''
                                          : LocalizationService.of(context)
                                                  ?.translate(
                                                      'create_agent_name_button_label') ??
                                              '',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
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
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'loader_button_label') ??
                                                ''
                                            : LocalizationService.of(context)
                                                    ?.translate(
                                                        'create_agent_name_button_label') ??
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
            )),
          ],
        ));
  }
}
