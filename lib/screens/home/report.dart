import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/order_list_response.dart';
import 'package:vendor_app/notifiers/report_notifier.dart';

class Report extends StatefulWidget {


  @override
  _ReportState createState() => _ReportState();
}




class _ReportState extends State<Report> {
  final double _paddingTop = 10;
  final double _paddingStart = 15;

  final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 3.0,
      ),
    ],
  );
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  DateChangeNotifier _dateChangeNotifier;
  ReportLoadingNotifier _reportLoadingNotifier;

  @override
  void initState() {
    super.initState();
    _dateChangeNotifier =
        Provider.of<DateChangeNotifier>(context, listen: false);
    _reportLoadingNotifier =
        Provider.of<ReportLoadingNotifier>(context, listen: false);
    _reportLoadingNotifier.setIsLoading(true);
    reportApi();
  }

  List<Order> orders = [];
  void reportApi() async {
    _reportLoadingNotifier.isLoading = true;
    // start_date,end_date
    var response = await ApiCall().execute<OrderPagination, Null>('report', {
      'start_date': _dateFormat(_startDate),
      'end_date': _dateFormat(_endDate)
    });
    // 'start_date': '01-01-2010', 'end_date': '10-12-2020'
    // });
    _reportLoadingNotifier.isLoading = false;
    orders = response.orders ?? [];
    // if()
  }

  Future<Null> _startDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != _startDate) {
      _startDate = picked;
      _dateChangeNotifier.dateSelected();
      reportApi();
    }
  }

  Future<Null> _endDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != _endDate) {
      _endDate = picked;
      _dateChangeNotifier.dateSelected();
      reportApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _padding = EdgeInsets.fromLTRB(
        _paddingStart, _paddingTop, _paddingStart, _paddingTop);
    return Scaffold(
        backgroundColor: Color(0xFFffffff),
        appBar: AppBar(
          title: Text('Report'),
          backgroundColor: colorPrimary,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      _paddingStart, _paddingTop, _paddingStart, _paddingTop),
                  decoration: _boxDecoration,
                  child: Row(
                    children: [
                      Expanded(
                        child: Consumer<DateChangeNotifier>(
                          builder: (context, value, child) => TextFormField(
                            controller: TextEditingController(
                                text: _dateFormat(_startDate)),
                            onTap: () => _startDatePicker(context),
                            obscureText: false,
                            enableInteractiveSelection: false,
                            onSaved: (value) {
                              // _guaranteePeriod = value;
                            },
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: Color(0xFFebebeb),
                                    width: 1.0,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                hintText: "Start Date",
                                suffixIcon: Icon(Icons.date_range)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Consumer<DateChangeNotifier>(
                          builder: (context, value, child) => TextFormField(
                            controller: TextEditingController(
                                text: _dateFormat(_endDate)),
                            onTap: () => _endDatePicker(context),
                            obscureText: false,
                            enableInteractiveSelection: false,
                            onSaved: (value) {
                              // _guaranteePeriod = value;
                            },
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(
                                    color: Color(0xFFebebeb),
                                    width: 1.0,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                hintText: "End Date",
                                suffixIcon: Icon(Icons.date_range)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<ReportLoadingNotifier>(
                    builder: (context, value, child) => ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          var order = orders[index];
                          return Row(
                            children: <Widget>[
                              Container(
                                padding: _padding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: colorPrimary,
                                      child: const Text(
                                        '#id',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      order.id,
                                      style: const TextStyle(
                                          // color: Colors.white,
                                          // fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Container(
                                color: Color(0xFFdcdcdc),
                                width: 1,
                                height: 50,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(_paddingStart,
                                      _paddingTop, 0, _paddingTop),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.shippingName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Icon(Icons.access_time_rounded,
                                              size: 14, color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: ' ${order.createdAt}',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ])),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: _padding,
                                child: Text(
                                  '$currency ${order.orderNetTotalAmount}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                        itemCount: orders.length),
                  ),
                ),
              ],
            ),
            Consumer<ReportLoadingNotifier>(
              builder: (context, value, child) {
                return value.isLoading ? progressBar : SizedBox();
              },
            )
          ],
        ));
  }

  String _dateFormat(DateTime date) {
    String dateStr =
        '${_setTwoDigitDay(date.day)}-${_setTwoDigitDay(date.month)}-${date.year}';
    debugPrint('MJM dateFormat: $dateStr    ${date.toLocal()}');
    return dateStr;
  }

  String _setTwoDigitDay(int day) {
    return '${day < 10 ? '0$day' : day}';
  }
}
