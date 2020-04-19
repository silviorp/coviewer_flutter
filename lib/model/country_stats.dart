import 'package:covidviewerflutter/model/country.dart';
import 'package:covidviewerflutter/model/daily_stat.dart';

class CountryStats {
  CountryStats({this.stats});

  CountryStats.full(
      {this.country,
      this.totalCases,
      this.totalDeaths,
      this.totalRecovered,
      this.totalNewCases,
      this.stats});

  Country country;
  int totalCases = 0;
  int totalNewCases = 0;
  int totalDeaths = 0;
  int totalNewDeaths = 0;
  int totalRecovered = 0;
  int totalNewRecovered = 0;
  List<DailyStat> stats;

  factory CountryStats.fromJson(List<dynamic> json) {
    List<DailyStat> dailyStats = <DailyStat>[];
    json.forEach((element) {
      dailyStats.add(DailyStat.fromJson(element as Map<String, dynamic>));
    });
    return CountryStats(stats: dailyStats);
  }

  void sortStatsByDate() {
    stats.sort((DailyStat a, DailyStat b) => a.date.compareTo(b.date));
  }

  void fillTotals() {
    this.totalCases = stats.last.confirmed;
    this.totalNewCases =
        stats.last.confirmed - stats[stats.length - 2].confirmed;
    this.totalDeaths = stats.last.deaths;
    this.totalNewDeaths = stats.last.deaths - stats[stats.length - 2].deaths;
    this.totalRecovered = stats.last.recovered;
    this.totalNewRecovered =
        stats.last.recovered - stats[stats.length - 2].recovered;
  }
}
