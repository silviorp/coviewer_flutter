import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  Future<String> getCountryName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCountry = prefs.getString('country') ?? 'global';
    return selectedCountry;
  }

  Future<void> setCountryName(String countryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', countryName);
  }
}
