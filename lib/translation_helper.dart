import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper {
  static getDeviceLanguage(BuildContext context) {
    var deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();

    switch (deviceLanguage) {
      case "tr":
        return LocaleType.tr;
      case "en":
        return LocaleType.en;
    }
  }
}