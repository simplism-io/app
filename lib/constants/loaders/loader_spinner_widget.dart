import 'package:flutter/material.dart';

class LoaderSpinnerWidget extends StatelessWidget {
  const LoaderSpinnerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onBackground)),
      )),
    );
  }
}
