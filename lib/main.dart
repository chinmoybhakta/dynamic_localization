import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:newflutter/api/app_locale.dart';
import 'package:newflutter/api/remote_language_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadLangJson().then((_) {
      _localization.init(
        mapLocales: AppLocale.map.entries
            .map((e) => MapLocale(e.key, e.value))
            .toList(),
        initLanguageCode: 'en',
      );

      _localization.onTranslatedLanguage = (locale) {
        setState(() {});
      };
    });
  }

  Future<void> loadLangJson() async {
    RemoteLanguageService remoteLanguageService = RemoteLanguageService();
    final data = await remoteLanguageService.fetchAllLang();

    for (var lang in data) {
      final code = lang?["code"];
      final fileUrl = lang?["file_url"];
      if (code != null && fileUrl != null) {
        await remoteLanguageService.addRemoteLangToAppLocale(code, fileUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : MaterialApp(
            supportedLocales: AppLocale.map.keys
                .map((code) => Locale(code)) 
                .toList(),
            localizationsDelegates: _localization.localizationsDelegates,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Bangla'),
                    onPressed: () {
                      localization.translate('bn');
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('عربي'),
                    onPressed: () {
                      localization.translate('ar');
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(AppLocale().tr("subscription_status")),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
