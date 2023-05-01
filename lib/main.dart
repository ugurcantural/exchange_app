import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/settings_cubit.dart';
import 'bloc/settings_state.dart';
import 'pages/home_page.dart';
import 'storage/storage.dart';
import 'theme/theme.dart';

Future<SettingsState> loadApp() async {
  final storage = AppStorage();
  var data = await storage.readAppSettings();

  if (data["darkMode"] == null) {
    if (ThemeMode.system == ThemeMode.dark) {
      data["darkMode"] = true;
    }
    else {
      data["darkMode"] = false;
    }
  }

  await storage.writeAppSettings(darkMode: data["darkMode"]);

  return SettingsState(
    darkMode: data["darkMode"],
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadApp().then((value) => runApp(MyApp(st: value)));
}

class MyApp extends StatelessWidget {
  final SettingsState st;
  const MyApp({super.key, required this.st});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(st),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Döviz Kurları',
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            home: const HomePage(),
          );
        }
      ),
    );
  }
}