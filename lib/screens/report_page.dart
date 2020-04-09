import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportPage extends StatefulWidget {
  final MainModel model;

  const ReportPage({Key key, this.model}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with AfterLayoutMixin<ReportPage> {
  bool _loading = false;
  String _loadingText = "Initialisation";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<charts.Series> _seriesList;
  List<charts.Series> _pieList;
  bool _animate_chart = true;

  @override
  void afterFirstLayout(BuildContext context) {
    _anonymeAuthenticate(context);
  }

  @override
  void initState() {
    super.initState();
    _seriesList = _createSampleData();
    _pieList = _createPieSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Rapport de Donation',
            style: TextStyle(color: Colors.blue),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[],
        ),
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
              text: _loadingText,
            )
          ],
        ),
      ),
    );
  }

  _bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          _headerView(),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text('Evolution des contributions',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _lineChart(),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Contributions par pays',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _pieChart()
        ],
      ),
    );
  }

  Widget _lineChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      child: new charts.TimeSeriesChart(
        _seriesList,
        animate: _animate_chart,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _pieChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 200,
      child: charts.PieChart(_pieList,
          animate: _animate_chart,
          defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.outside)
          ])),
    );
  }

  _headerView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Total Contributions",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '5000 \$',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Contributions Hebdo",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '1000 \$',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  static List<charts.Series<LinearSales, int>> _createPieSampleData() {
    final data = [
      new LinearSales("SEN", 100),
      new LinearSales("RDC", 75),
      new LinearSales("EGY", 25),
      new LinearSales("RSA", 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.sales,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.country}: ${row.sales}',
      )
    ];
  }

  void _anonymeAuthenticate(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    var connected = widget.model.aconnected;
    print('checking connected....$connected');

    if (!connected) {
      var authentification = await widget.model.anonymousAuth();
      print('auth res $authentification');
      checkErrorMessge(authentification);
    }
  }

  checkErrorMessge(res) {
    setState(() {
      _loading = false;
    });
    if (!res['status']) {
      var msg = res.containsKey('msg')
          ? res['msg']
          : "Une Erreur s'est produite. Veuillez contacter l'Admin";
      showSnackBar(context, msg, status: false, duration: 5);
    }
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class LinearSales {
  final String country;
  final int sales;

  LinearSales(this.country, this.sales);
}
