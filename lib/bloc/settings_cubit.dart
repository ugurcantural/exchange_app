import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_state.dart';
import '../storage/storage.dart';

class SettingsCubit extends Cubit<SettingsState>{
  SettingsCubit(super.initialState);
  
  changeDarkMode(bool darkMode) async {
    final newState = SettingsState(
      darkMode: darkMode,
    );

    final storage = AppStorage();
    await storage.writeAppSettings(
      darkMode: darkMode,
    );

    emit(newState);
  }

}