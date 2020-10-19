import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  String selectedCountry;

  Future<void> getCountryName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCountry = prefs.getString('country') ?? 'global';
  }

  Future<void> setCountryName(String countryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', countryName);
    selectedCountry = countryName;
  }
}
