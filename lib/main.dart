import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:starter_project/settings_screen.dart';
import 'dart:ui' as ui;

import 'package:starter_project/styles/my_themes.dart';
import 'package:starter_project/utils/cupertino_loc_delegate.dart';
import 'package:starter_project/utils/language_provider.dart';

void main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(EasyLocalization(child: MyApp()));
}

class MyApp extends StatelessWidget {
  static const list = [
    Locale('en', 'US'),
    Locale('ar', 'TN'),
    Locale('it', 'IT'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('zh', 'CH'),
    Locale('de', 'DE')
  ];

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final windowLocale = ui.window.locale;
    final Locale locale = MyApp.list.indexOf(windowLocale) != -1
        ? windowLocale
        : Locale('en', 'US');

    return EasyLocalizationProvider(
      data: data,
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => MyThemes.themes[0],
        themedWidgetBuilder: (context, theme) => MaterialApp(
          title: 'Flutter Starter Project',
          localizationsDelegates: [
            const FallbackCupertinoLocalisationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            //app-specific localization
            EasylocaLizationDelegate(
                locale: locale, path: 'assets/langs', useOnlyLangCode: true),
          ],
          supportedLocales: MyApp.list,
          locale: data.savedLocale == null ? locale : data.savedLocale,
          debugShowCheckedModeBanner: false,
          theme: theme,
          initialRoute: "/",
          routes: {
            '/': (_) => LanguageProvider(child: MyHomePage(),),
            '/settings': (_) => LanguageProvider(child: SettingsScreen(),)
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getSavedTheme();
  }


  getSavedTheme() async {
    final _theme = await MyThemes.getSavedTheme();
    try {
      DynamicTheme.of(context).setThemeData(_theme);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(lang.tr("home.title")),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: Icon(Icons.settings, color: Colors.white,),
            )
          ],
        ),
        body: Center(
          child: Text(
            lang.tr("home.text"),
            style: Theme.of(context).textTheme.display1,
          ),
        ));
  }
}



