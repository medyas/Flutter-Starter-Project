import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starter_project/widgets/DropDownPreferenceWidget.dart';
import 'package:starter_project/main.dart';
import 'package:starter_project/styles/my_themes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final mList = MyApp.list.map((item) => item.toLanguageTag()).toList();
  final List list = [
    "English",
    "Arabic",
    "Italian",
    "Spanish",
    "French",
    "Chinese",
    "German"
  ];
  final valuesThemes = MyThemes.themes.asMap().keys.toList();

  Locale getLocale(String val) => MyApp.list.firstWhere(
          (item) => val == "${item.languageCode}-${item.countryCode}");

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      setSelectedTheme();
    }
  }

  Widget _renderContainer(Color color) => Container(
        height: 56,
        width: 56,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: color,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    final langs = AppLocalizations.of(context);

    final defaultLan = mList.firstWhere((item) =>
    item.toString().toLowerCase().substring(0, 2) ==
        langs.locale.languageCode);

    final defaultThemes = MyThemes.themes
        .map((theme) => _renderContainer(theme.primaryColor))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(langs.tr('settings.title')),
      ),
      body: PreferencePage([
        PreferenceTitle(langs.tr('settings.langs')),
        DropdownPreference(
          langs.tr("settings.lang_select"),
          'app_lang',
          defaultVal: defaultLan,
          values: mList,
          displayValues: list,
          onChange: (val) {
            this.setState(() {
              data.changeLocale(getLocale(val));
            });
          },
        ),
        PreferenceTitle(langs.tr("settings.personalization")),
        DropDownPreferenceWidget(
          langs.tr("settings.theme"),
          'app_theme',
          defaultVal: 0,
          values: valuesThemes,
          displayValues: defaultThemes,
          onChange: (val) => changeColor(val.toString()),
        ),
      ]),
    );
  }

  void changeColor(String val) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("app_theme", val);
    DynamicTheme.of(context).setThemeData(MyThemes.getThemeFromIndex(val));
  }

  Future<void> setSelectedTheme() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final val = pref.getString("app_theme");
      DynamicTheme.of(context).setThemeData(MyThemes.getThemeFromIndex(val));
    } catch (e) {
      print(e);
      DynamicTheme.of(context).setThemeData(MyThemes.getThemeFromIndex("0"));
    }
  }
}
