import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext{
  void showSnackBar ({required String message,bool error = false}){
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
       content: Text(message),
        duration: Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: error? Colors.red : Colors.green,
     ),
    );
  }
  AppLocalizations get localization => AppLocalizations.of(this)!;
}