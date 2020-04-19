import 'package:covidviewerflutter/viewmodel/covid_home_viewmodel.dart';
import 'package:covidviewerflutter/widgets/covid_timeseries_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CovidHomeViewModel>(context);
    return Scaffold(
      backgroundColor: Color(0xff111517),
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light, // Make StatusBar text white
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildTopSection(viewModel),
                _buildMiddleSection(viewModel),
                _buildBottomSection(viewModel)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(CovidHomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.blueGrey[900],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'CoViewer',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          viewModel.selected?.country?.iso2Lower == 'global'
              ? Image.network(
                  'https://icons.iconarchive.com/icons/icons-land/vista-flags/256/United-Nations-Flag-1-icon.png',
                  width: 24.0,
                )
              : (viewModel.selected?.country?.iso2Lower != null
                  ? Image.network(
                      'https://www.countryflags.io/${viewModel.selected.country.iso2Lower}/shiny/24.png',
                    )
                  : Container()),
          viewModel.isLoadingStats
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 16.0,
                    width: 16.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white54,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    _showPickerModal(context, viewModel);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(CovidHomeViewModel viewModel) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0x121517),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: CovidTimeSeriesChart(
                  chartData: viewModel.getValidCases(),
                  title: 'Daily Cases',
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: CovidTimeSeriesChart(
                      chartData: viewModel.getValidDeaths(),
                      title: 'Daily Deaths',
                    )),
                Expanded(
                    flex: 1,
                    child: CovidTimeSeriesChart(
                      chartData: viewModel.getValidRecovered(),
                      title: 'Daily Recovered',
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(CovidHomeViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color(0x121517),
      height: 180.0,
      child: viewModel.isLoadingStats
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            )
          : (viewModel.loadStatsException != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Error loading Stats',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 24.0,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () => viewModel.fetchStats(),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.blue,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Try Again',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      viewModel.selected?.country?.name ?? '',
                      style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: _getStatItem(
                              Colors.blue,
                              'Cases',
                              viewModel.selected?.totalCases ?? 0,
                              viewModel.selected?.totalNewCases ?? 0),
                        ),
                        Expanded(
                          flex: 1,
                          child: _getStatItem(
                              Colors.red,
                              'Deaths',
                              viewModel.selected?.totalDeaths ?? 0,
                              viewModel.selected?.totalNewDeaths ?? 0),
                        ),
                        Expanded(
                          flex: 1,
                          child: _getStatItem(
                              Colors.green,
                              'Recovered',
                              viewModel.selected?.totalRecovered ?? 0,
                              viewModel.selected?.totalNewRecovered ?? 0),
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }

  Widget _getStatItem(Color squareColor, String text, int value, int newValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.0,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: squareColor,
        ),
        child: Column(
          children: <Widget>[
            Text(
              '$text',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Text(
              '$value',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              'Daily',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Text(
              '$newValue',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Future _showPickerModal(
      BuildContext context, CovidHomeViewModel viewModel) async {
    final items =
        viewModel.countries?.toList()?.map((item) => item.name)?.toList();

    if (items == null) {
      return;
    }

    new Picker(
      adapter: PickerDataAdapter<String>(pickerdata: items),
      changeToFirst: true,
      hideHeader: false,
      selecteds: [
        items.indexWhere(
                (element) => element == viewModel.selected.country.name) ??
            0
      ],
      height: 300.0,
      backgroundColor: Colors.blueGrey[900],
      headercolor: Colors.blueGrey[900],
      textStyle: TextStyle(
        color: Colors.white54,
        fontSize: 24.0,
      ),
      onConfirm: (Picker picker, List value) {
        viewModel.selectCountry(picker.adapter.text);
      },
    ).showModal(this.context);
  }
}
