import 'package:shared_preferences/shared_preferences.dart';

class SharedTools {

  /// Envoie des données dans les shared préférences pour la sauvegarde
  void sendUserInformations(int userWeight, int userHeight, int manOrWoman) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('weight', userWeight);
    await sharedPreferences.setInt('height', userHeight);
    await sharedPreferences.setInt('manOrWoman', manOrWoman);
  }

  /// Récupération du poids de l'utilisateur
  Future<int> getUserWeight() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('weight');
  }

  /// Récupération de la taille de l'utilisateur
  Future<int> getUserHeight() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('height');
  }

  /// Récupération du genre de l'utilisateur
  Future<int> getUserGender() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('manOrWoman');
  }
}