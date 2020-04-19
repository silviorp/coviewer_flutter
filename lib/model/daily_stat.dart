class DailyStat {
  DailyStat({this.date, this.confirmed, this.deaths, this.recovered});

  DateTime date;
  int confirmed;
  int deaths;
  int recovered;

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    final dateList = json['date'].toString().split('-');
    final parsedDate = DateTime.utc(
        int.parse(dateList[0]), int.parse(dateList[1]), int.parse(dateList[2]));
    return DailyStat(
      date: parsedDate,
      confirmed: json['confirmed'],
      deaths: json['deaths'],
      recovered: json['recovered'],
    );
  }
}
