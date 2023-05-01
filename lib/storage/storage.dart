import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  
  readAppSettings() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    
    var darkMode = storage.getBool('darkMode');

    return {
      "darkMode": darkMode,
    };
  }

  writeAppSettings({required bool darkMode}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setBool('darkMode', darkMode);
  }

}