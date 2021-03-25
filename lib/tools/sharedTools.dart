import 'package:shared_preferences/shared_preferences.dart';

class SharedTools {
  /// Envoie des données dans les shared préférences pour la sauvegarde
  void sendUserInformations(int userWeight, int gender) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('userWeight', userWeight);
      prefs.setInt('userGender', gender);
    });
  }

  /// Renvoie le booléen pour savoir si l'utilisateur a déjà enregistré ses données
  Future<bool> isAlreadyIn() async {
    return await SharedPreferences.getInstance()
        .then((pref) => pref.getBool('alreadyIn'));
  }
}
