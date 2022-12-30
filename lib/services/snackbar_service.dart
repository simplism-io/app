import 'package:flutter/material.dart';

import 'localization_service.dart';

class SnackBarService {
  successSnackBar(localization, context) {
    final successSnackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content:
          Text(LocalizationService.of(context)?.translate('localization') ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
    );
    return ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
  }

  errorSnackBar(localization, context) {
    final errorSnackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content:
          Text(LocalizationService.of(context)?.translate(localization) ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
    );
    return ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }
}
