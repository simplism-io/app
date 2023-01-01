import 'package:base/widgets/screens/private/create_agent_name_screen_widget.dart';
import 'package:flutter/material.dart';

import '../../services/agent_service.dart';
import '../loaders/loader_spinner_widget.dart';
import '../screens/private/home_screen_widget.dart';

class HomeScreenFutureBuilderWidget extends StatelessWidget {
  const HomeScreenFutureBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final agent = snapshot.data!;
            if (agent['name'] == null || agent['name'] == '') {
              return const CreateAgentNameScreenWidget();
            }
            return HomeScreenWidget(agent: agent);
          }
          if (!snapshot.hasData) {
            //return const CreateOrganisationScreenWidget();
          }
        }
        return const LoaderSpinnerWidget();
      },
      future: AgentService().loadAgent(),
    );
  }
}
