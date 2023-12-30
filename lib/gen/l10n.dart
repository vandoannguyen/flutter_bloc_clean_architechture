// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Languages {
  Languages();

  static Languages? _current;

  static Languages get current {
    assert(_current != null,
        'No instance of Languages was loaded. Try to initialize the Languages delegate before accessing Languages.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Languages> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Languages();
      Languages._current = instance;

      return instance;
    });
  }

  static Languages of(BuildContext context) {
    final instance = Languages.maybeOf(context);
    assert(instance != null,
        'No instance of Languages present in the widget tree. Did you add Languages.delegate in localizationsDelegates?');
    return instance!;
  }

  static Languages? maybeOf(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Languages> load(Locale locale) => Languages.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
