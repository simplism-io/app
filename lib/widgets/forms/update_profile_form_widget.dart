import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/agent_model.dart';

import '../buttons/update_profile_button_widget.dart';
import '../form_fields/avatar_form_field_widget.dart';
import '../form_fields/email_form_field_widget.dart';
import '../headers/profile_header_widget.dart';

class UpdateProfileFormWidget extends StatefulWidget {
  final AgentModel? profile;
  final Uint8List? avatarBytes;

  const UpdateProfileFormWidget(
      {super.key, required this.profile, this.avatarBytes});

  @override
  State<UpdateProfileFormWidget> createState() =>
      _UpdateProfileFormWidgetState();
}

class _UpdateProfileFormWidgetState extends State<UpdateProfileFormWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const ProfileHeaderWidget(),
                const SizedBox(height: 30.0),
                AvatarFormFieldWidget(avatarBytes: widget.avatarBytes),
                const SizedBox(height: 50.0),
                EmailFormFieldWidget(email: widget.profile!.email),
                const SizedBox(height: 15),
                //NameFormFieldWidget(fullName: widget.profile!.name),
                const SizedBox(height: 15.0),
                UpdateProfileButtonWidget(formKey: formKey)
              ],
            )),
      ),
    );
  }
}
