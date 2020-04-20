import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covidviewerflutter/model/chart_stat_data.dart';
import 'package:flutter/material.dart';

class CovidTimeSeriesChart extends StatefulWidget {
  CovidTimeSeriesChart({Key key, this.chartData, this.title}) : super(key: key);

  final List<ChartStatData> chartData;
  final String title;

  @override
  _CovidTimeSeriesChartState createState() => _CovidTimeSeriesChartState();
}

class _CovidTimeSeriesChartState extends State<CovidTimeSeriesChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(color: Colors.white30),
          ),
          Expanded(
            child: _getChartWidget(),
          ),
        ],
      ),
    );
  }

  charts.TimeSeriesChart _getChartWidget() {
    return charts.TimeSeriesChart(
      _getChartSeries(),
      animate: true,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
    );
  }

  List<charts.Series<ChartStatData, DateTime>> _getChartSeries() {
    return [
      charts.Series(
        id: 'Cases',
        domainFn: (ChartStatData data, _) => data.date,
        measureFn: (ChartStatData data, _) => data.count,
        colorFn: (ChartStatData data, _) =>
            charts.MaterialPalette.blue.shadeDefault,
        data: widget.chartData,
      ),
    ];
  }
}
