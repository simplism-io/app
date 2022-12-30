import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../forms/create_agent_name_form_widget.dart';

class CreateAgentNameScreenWidget extends StatelessWidget {
  const CreateAgentNameScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Center(
            child: Column(
          children: const [
            CreateAgentNameFormWidget(),
          ],
        )));
  }
}
