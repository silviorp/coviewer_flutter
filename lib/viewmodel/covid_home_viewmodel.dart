import 'package:covidviewerflutter/model/country.dart';
import 'package:covidviewerflutter/model/country_stats.dart';
import 'package:covidviewerflutter/model/daily_stat.dart';
import 'package:covidviewerflutter/repository/covid_repository.dart';
import 'package:flutter/material.dart';

class CovidHomeViewModel with ChangeNotifier {
  CovidHomeViewModel() {
    this.repository = CovidRepository();
    fetchStats();
  }

  CovidRepository repository;
  List<Country> countries;
  List<CountryStats> stats;
  CountryStats selected;
  bool isLoadingStats = false;
  bool isLoadingCountries = false;
  Exception loadStatsException;

  Future<void> fetchStats() async {
    _setLoadingStats(true);

    this.stats = await repository.getAllStats();

    _fetchCountries();
    _setSelected();
    _setLoadingStats(false);
  }

  void _setSelected() {
    this.selected =
        stats.firstWhere((element) => element.country.iso2Lower == 'global');
  }

  void _fetchCountries() {
    _setLoadingCountries(true);
    countries = <Country>[];
    stats.forEach((element) {
      countries.add(element.country);
    });
    _setLoadingCountries(false);
  }

  void selectCountry(String countryName) {
    this.selected = this.stats.firstWhere(
        (element) =>
            element.country.name.contains(_clearSelection(countryName)),
        orElse: null);
    notifyListeners();
  }

  String _clearSelection(String selection) =>
      selection.substring(1, selection.length - 1);

  void _setLoadingStats(bool isLoading) {
    this.isLoadingStats = isLoading;
    notifyListeners();
  }

  void _setLoadingCountries(bool isLoading) {
    this.isLoadingCountries = isLoading;
    notifyListeners();
  }

  List<DailyStat> getValidCases() {
    return selected?.stats
            ?.where((element) => element.confirmed > 0)
            ?.toList() ??
        <DailyStat>[];
  }

  List<DailyStat> getValidDeaths() {
    return selected?.stats?.where((element) => element.deaths > 0)?.toList() ??
        <DailyStat>[];
  }

  List<DailyStat> getValidRecovered() {
    return selected?.stats
            ?.where((element) => element.recovered > 0)
            ?.toList() ??
        <DailyStat>[];
  }
}
