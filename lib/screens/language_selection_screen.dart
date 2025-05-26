import 'package:app/l10n/l10n.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/provider/local_provider.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends BaseRoute {
  const ChooseLanguageScreen({super.key, super.a, super.o}) : super(r: 'ChooseLanguageScreen');

  @override
  BaseRouteState<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends BaseRouteState<ChooseLanguageScreen> {
  bool isFavourite = false;
  late int selectedLangIndex;
  late Locale locale;

  _ChooseLanguageScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Select Language'),
        ),
        bottomNavigationBar: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await _setLang();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Set Language'),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: L10n.languageListName.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: RadioListTile(
                        value: L10n.all[index].languageCode,
                        groupValue: global.languageCode,
                        onChanged: (dynamic val) {
                          global.languageCode = val;
                          selectedLangIndex = index;

                          setState(() {});
                        },
                        title: Text(
                          L10n.languageListName[index],
                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
    );
  }



  _setLang() {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BottomNavigationWidget(
                  a: widget.analytics,
                  o: widget.observer,
                )),
      );
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      locale = Locale(L10n.all[selectedLangIndex].languageCode);
      provider.setLocale(locale);
      global.languageCode = locale.languageCode;
      global.sp.setString('selectedLanguage', global.languageCode!);

      if (global.rtlLanguageCodeLList.contains(locale.languageCode)) {
        global.isRTL = true;
      } else {
        global.isRTL = false;
      }
      setState(() {});
    } catch (e) {
      debugPrint("Exception - language_selection_screen.dart - _setLang():$e");
    }
  }
}
