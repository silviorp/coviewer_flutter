import 'dart:collection';
import 'dart:convert';

import 'package:covidviewerflutter/model/country.dart';
import 'package:covidviewerflutter/model/country_stats.dart';
import 'package:covidviewerflutter/model/daily_stat.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CovidRepository {
  static const _covidApiUrl =
      'https://pomber.github.io/covid19/timeseries.json';

  Future<List<CountryStats>> getAllStats() async {
    final countries = await getCountries();
    final summaryResponse = await http.get(_covidApiUrl);
    final jsonDecoded = json.decode(summaryResponse.body);

    final stats = _parseCountryStats(jsonDecoded, countries);
    stats.insert(0, _getGlobalStat(stats));
    return stats;
  }

  Future<List<Country>> getCountries() async {
    final countriesJson = await rootBundle.loadString("assets/countries.json");
    final countries = Country.parseCountries(json.decode(countriesJson));
    return countries;
  }

  List<CountryStats> _parseCountryStats(jsonDecoded, List<Country> countries) {
    List<CountryStats> countryStatsList = <CountryStats>[];
    (jsonDecoded as LinkedHashMap<String, dynamic>)
        .forEach((countryName, value) {
      final country = countries.firstWhere(
          (country) => country.name.contains(countryName),
          orElse: () => null);

      if (country != null) {
        final countryStats = CountryStats.fromJson(value);
        countryStats.country = country;
        countryStats.sortStatsByDate();
        countryStats.fillTotals();
        countryStatsList.add(countryStats);
      }
    });

    return countryStatsList;
  }

  CountryStats _getGlobalStat(List<CountryStats> stats) {
    final country = Country.getGlobal();
    int totalCases = 0;
    int totalDeaths = 0;
    int totalRecovered = 0;
    int totalNewCases = 0;

    List<DailyStat> dailyStats = <DailyStat>[];

    stats.forEach((element) {
      totalCases += element.totalCases;
      totalDeaths += element.totalDeaths;
      totalRecovered += element.totalRecovered;
      totalNewCases += element.totalNewCases;

      element.stats.forEach((element) {
        final index = dailyStats
            .indexWhere((dailyStat) => dailyStat.date == element.date);

        if (index != -1) {
          dailyStats[index].confirmed += element.confirmed;
          dailyStats[index].deaths += element.deaths;
          dailyStats[index].recovered += element.recovered;
        } else {
          dailyStats.add(DailyStat(
              date: element.date,
              confirmed: element.confirmed,
              deaths: element.deaths,
              recovered: element.recovered));
        }
      });
    });

    return CountryStats.full(
        country: country,
        totalDeaths: totalDeaths,
        totalCases: totalCases,
        totalNewCases: totalNewCases,
        totalRecovered: totalRecovered,
        stats: dailyStats);
  }
}
