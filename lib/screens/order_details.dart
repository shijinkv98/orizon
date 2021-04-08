import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/order_list_response.dart'
    show Order, OrderDetailsResponse, OrderItems, Timeline;
import 'package:vendor_app/notifiers/order_details_notifier.dart';

import 'home/orders.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderItems orderItems;
  String orderId = "0";
  OrderDetailsScreen({Key key, @required this.orderItems}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

TextStyle _titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

class _OrderDetailsState extends State<OrderDetailsScreen> {
  final double _paddingTop = 10;
  final double _paddingStart = 10;
  final double _paddingTableRow = 7;
  final BoxDecoration _boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5.0,
      ),
    ],
  );
  OrderTimelineNotifier _timelineNotifier;
  OrderDetailsLoadingNotifier _loadingNotifier;
  List<Timeline> _timeline;
  @override
  void initState() {
    super.initState();
    _timelineNotifier =
        Provider.of<OrderTimelineNotifier>(context, listen: false);
    _loadingNotifier =
        Provider.of<OrderDetailsLoadingNotifier>(context, listen: false);
    _loadingNotifier.setLoading(true);
    // /vendor/order-details/<order_id>	id,token, item_id
    ApiCall().execute<OrderDetailsResponse, Null>(
        'vendor/order-details/${widget.orderItems.orderData.id}',
        {'item_id': widget.orderItems.item.id}).then((value) {
      _loadingNotifier.isLoading = false;
      _timeline = value?.timeline;
      _timelineNotifier.responseReceived();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
          backgroundColor: colorPrimary,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: EdgeInsets.fromLTRB(
                        _paddingStart, _paddingTop, _paddingStart, _paddingTop),
                    decoration: _boxDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order # ${widget.orderItems.item.orderId}'),
                              Row(
                                children: [
                                  Text('Order Status'),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 2, 5.0, 2),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Theme.of(context).primaryColor),
                                    child: Text(
                                        widget.orderItems.orderData.orderStatus,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              Text(
                                  'Time: ${widget.orderItems.orderData.createdAt}'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 27.0,
                              child: widget.orderItems.orderData.orderStatus!="Confirmed"?RaisedButton(
                                padding: EdgeInsets.all(0),
                                onPressed: ()
                                async {
                                  Map body = {
                                    'id': widget.orderItems.orderData.id,
                                  };

                                  ApiCall()
                                      .qpprove_reject(
                                    'activateorder',
                                    body,
                                  )
                                      .then((value) {
                                    String message = value['message'];
                                    ApiCall().showToast(message);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Orders()),
                                    );
                                  });
                                },
                                child: Text(
                                  'Accept ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
                              ):Container(),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 27.0,
                              child: widget.orderItems.orderData.orderStatus!="Cancelled"?RaisedButton(
                                padding: EdgeInsets.all(0),

                                onPressed: () async {
                                  Map body = {
                                    'id': widget.orderItems.orderData.id,
                                  };

                                  ApiCall()
                                      .qpprove_reject(
                                    'deactivateorder',
                                    body,
                                  )
                                      .then((value) {
                                    String message = value['message'];
                                    ApiCall().showToast(message);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Orders()),
                                    );
                                  });
                                },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.red,
                              ):Container(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: EdgeInsets.fromLTRB(_paddingStart, _paddingTop,
                          _paddingStart, _paddingTop),
                      decoration: _boxDecoration,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.orderItems.item.productName),
                              SizedBox(
                                height: 2,
                              ),
                              Text('Qty: ${widget.orderItems.item.quantity}'),
                            ],
                          )),
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/images/no_image.png',
                            image:
                                '$productThumbUrl${widget.orderItems.item.image}',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        EdgeInsets.fromLTRB(0, _paddingTop, 0, _paddingTop),
                    decoration: _boxDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: _paddingStart, right: _paddingStart),
                          child: Text(
                            'Payment Summery',
                            style: _titleStyle,
                          ),
                        ),
                        SizedBox(
                          height: _paddingTop,
                        ),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: getTableData(),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _paddingStart, right: _paddingStart),
                          child: Column(
                            children: [
                              Divider(),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('Sub Total')),
                                  Text(
                                      '$currency ${widget.orderItems.orderData.orderTotalAmount}'),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Expanded(child: Text('Delivery charges')),
                                  Text(
                                      '$currency ${widget.orderItems.orderData.orderShippingCharge}'),
                                  // Text('0.0'),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Expanded(child: Text('Grand Total')),
                                  Text(
                                      '$currency ${widget.orderItems.orderData.orderNetTotalAmount}'),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: EdgeInsets.fromLTRB(_paddingStart, _paddingTop,
                          _paddingStart, _paddingTop),
                      decoration: _boxDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery Address', style: _titleStyle),
                              SizedBox(
                                height: _paddingTop,
                              ),
                              Text(widget.orderItems.orderData.shippingName,
                                  style: TextStyle(color: Colors.black)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.orderItems.orderData
                                    .getShippingAddress(),
                                style: TextStyle(
                                    color: Colors.black54, height: 1.3),
                              ),
                            ],
                          )),
                          SizedBox(
                            width: 50,
                          ),
                          RaisedButton.icon(
                              onPressed: () async {
                                String phone =
                                    widget.orderItems.orderData.shippingPhone;
                                if (phone != null && phone.trim().isNotEmpty) {
                                  phone = 'tel:$phone';
                                  if (await canLaunch(phone)) {
                                    await launch(phone);
                                  }
                                }
                              },
                              color: primaryTextColor,
                              icon: Icon(
                                Icons.headset_mic_sharp,
                                size: 18,
                              ),
                              // padding: EdgeInsets.only(left: 5, right: 5),
                              textColor: Colors.white,
                              label: Text(
                                'Call Customer',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ))
                        ],
                      )),
                  Consumer<OrderTimelineNotifier>(
                    builder: (context, value, child) {
                      List<Widget> chidrens = [
                        Text('Order Timeline', style: _titleStyle),
                        SizedBox(
                          height: _paddingTop,
                        ),
                      ];
                      if (_timeline != null && _timeline.isNotEmpty) {
                        _timeline.forEach((element) {
                          chidrens.add(
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      element.statusHistory?.statusText ?? ''),
                                ),
                                Text(element.createdAt),
                              ],
                            ),
                          );
                          chidrens.add(
                            SizedBox(
                              height: 3,
                            ),
                          );
                        });
                        return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            padding: EdgeInsets.fromLTRB(_paddingStart,
                                _paddingTop, _paddingStart, _paddingTop),
                            decoration: _boxDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: chidrens,
                            ));
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                ],
              ),
            ),
            Consumer<OrderDetailsLoadingNotifier>(
              builder: (context, value, child) {
                return value.isLoading ? progressBar : SizedBox();
              },
            )
          ],
        ));
  }

  List<TableRow> getTableData() {
    List<TableRow> rows = [
      TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(40)),
          children: [
            TableCell(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  _paddingStart, _paddingTableRow, 0, _paddingTableRow),
              child: Text('Item'),
            )),
            TableCell(
              child: Text('Qty'),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
            // TableCell(
            //   child: Text('Price'),
            //   verticalAlignment:
            //       TableCellVerticalAlignment.middle,
            // ),
            TableCell(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: _paddingStart),
                child: Text('Amount'),
              ),
              verticalAlignment: TableCellVerticalAlignment.middle,
            ),
          ]),
    ];
    rows.addAll(
        widget.orderItems.orderData.itemsNew.map((item) => TableRow(children: [
              TableCell(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(
                    _paddingStart, _paddingTableRow, 0, _paddingTableRow),
                child: Text(item.productName),
              )),
              TableCell(
                child: Text(item.quantity),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
              // TableCell(
              //   child: Text(item.amount),
              //   verticalAlignment:
              //       TableCellVerticalAlignment.middle,
              // ),
              TableCell(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: _paddingStart),
                  child: Text(item.amount),
                ),
                verticalAlignment: TableCellVerticalAlignment.middle,
              ),
            ])));

    return rows;
  }
}
