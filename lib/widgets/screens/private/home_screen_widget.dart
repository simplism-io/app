import 'dart:async';

import 'package:base/widgets/sections/message_section_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/agent_model.dart';
import '../../../services/agent_service.dart';
import '../../drop_downs/language_drawer_dropdown_widget.dart';
import '../../headers/private_end_drawer_header_widget.dart';
import '../../icons/private_drawer_icon_widget.dart';
import '../../icons/private_end_drawer_icon_widget.dart';
import '../../links/logo_header_link_widget.dart';
import '../../links/profile_drawer_link_widget.dart';
import '../../links/signout_drawer_link_widget.dart';
import '../../switchers/biometrics_drawer_switcher_widget.dart';
import '../../switchers/theme_drawer_switcher_widget.dart';

final supabase = Supabase.instance.client;

class HomeScreenWidget extends StatefulWidget {
  final AgentModel? agent;
  const HomeScreenWidget({Key? key, required this.agent}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  Uint8List? avatarBytes;

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Row(
              children: [
                const SizedBox(height: 5),
                const Text('All Messages'),
                Column(
                  children: [
                    const SizedBox(height: 4),
                    SizedBox(
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  rightSection() {
    return const ResponsiveRowColumnItem(
        rowFlex: 2, child: MessageSectionWidget());
  }

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  endDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PrivateEndDrawerHeaderWidget(),
          const SizedBox(height: 20.0),
          ProfileDrawerLinkWidget(agent: widget.agent),
          const SizedBox(height: 5.0),
          const LanguageDrawerDropdownWidget(),
          const ThemeDrawerSwitcherWidget(),
          const BiometricsDrawerSwitcherWidget(),
          const SizedBox(height: 50),
          const SignOutDrawerLink()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            PrivateDrawerIconWidget(),
            LogoHeaderLinkWidget()
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [PrivateEndDrawerWidget()],
      ),
      body: SingleChildScrollView(
        child: ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          rowPadding: const EdgeInsets.all(20),
          columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          children: [leftSection(), rightSection()],
        ),
      ),
      drawer: drawer(),
      endDrawer: endDrawer(),
    );
  }
}
