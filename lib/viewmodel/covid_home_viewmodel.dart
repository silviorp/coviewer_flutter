import 'package:covidviewerflutter/model/chart_stat_data.dart';
import 'package:covidviewerflutter/model/country.dart';
import 'package:covidviewerflutter/model/country_stats.dart';
import 'package:covidviewerflutter/repository/covid_repository.dart';
import 'package:covidviewerflutter/storage/user_storage.dart';
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
  UserStorage storage = UserStorage();

  Future<void> fetchStats() async {
    _setLoadingStats(true);

    this.stats = await repository.getAllStats();

    _fetchCountries();
    await storage.getCountryName();
    _setSelected();
    _setLoadingStats(false);
  }

  void _setSelected() {
    storage.selectedCountry == 'global'
        ? this.selected =
            stats.firstWhere((element) => element.country.iso2Lower == 'global')
        : this.selected = this.stats.firstWhere(
            (element) => element.country.name
                .contains(_clearSelection(storage.selectedCountry)),
            orElse: null);
  }

  void _fetchCountries() {
    _setLoadingCountries(true);
    countries = <Country>[];
    stats.forEach((element) {
      countries.add(element.country);
    });
    _setLoadingCountries(false);
  }

  Future<void> selectCountry(String countryName) async {
    this.selected = this.stats.firstWhere(
        (element) =>
            element.country.name.contains(_clearSelection(countryName)),
        orElse: null);
    await storage.setCountryName(_clearSelection(countryName));
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

  List<ChartStatData> getValidCases() {
    return selected?.stats
            ?.where((element) => element.confirmed > 0)
            ?.toList()
            ?.map((e) => ChartStatData(date: e.date, count: e.confirmed))
            ?.toList() ??
        <ChartStatData>[];
  }

  List<ChartStatData> getValidDeaths() {
    return selected?.stats
            ?.where((element) => element.deaths > 0)
            ?.toList()
            ?.map((e) => ChartStatData(date: e.date, count: e.deaths))
            ?.toList() ??
        <ChartStatData>[];
  }

  List<ChartStatData> getValidRecovered() {
    return selected?.stats
            ?.where((element) => element.recovered > 0)
            ?.toList()
            ?.map((e) => ChartStatData(date: e.date, count: e.recovered))
            ?.toList() ??
        <ChartStatData>[];
  }
}
