import 'package:shared_preferences/shared_preferences.dart';

class SharedTools {
  /// Envoie des données dans les shared préférences pour la sauvegarde
  Future sendUserInformations(int userWeight, int gender) async {
    return await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('userWeight', userWeight);
      prefs.setInt('userGender', gender);
    });
  }
}
