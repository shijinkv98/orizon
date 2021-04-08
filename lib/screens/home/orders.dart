import 'package:flutter/material.dart';
import 'package:vendor_app/custom/custom_tabview.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/order_list_response.dart';
import 'package:vendor_app/screens/home/home.dart';

class Orders extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}
int position=0;
class _OrderState extends State<Orders> {
  @override
  void initState() {

    super.initState();
  }

  TextStyle _tabTextStyle = TextStyle(
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    debugPrint('MJM orders build()');
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: colorPrimary,
      ),
      body: FutureBuilder<OrdersListResponse>(
        future: ApiCall().execute<OrdersListResponse, Null>('orders', null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _getView(context, snapshot.data.ordersData.orders);
          } else if (snapshot.hasError) {
            return errorScreen('Error: ${snapshot.error}');
          } else {
            return progressBar;
          }
        },
      ),
    );
  }

  Widget _getView(BuildContext context, List<OrderStaus> orderStatus) =>
      CustomTabView(
        initPosition: tbPosition,
        itemCount: orderStatus.length,
        tabBuilder: (context, index) => Tab(text: orderStatus[index].status),
        pageBuilder: (context, index) =>
            _listview(orderStatus[index].orderPagination),
        onPositionChange: (index) {
          print('current position: $index');
          // initPosition = index;
        },
        onScroll: (position) => print('$position'),
      );

  Widget _listview(OrderPagination orderPagination) => ListView.builder(
      itemBuilder: (context, index) =>
          _itemsBuilder(context, orderPagination.getOrderItems()[index]),
      // separatorBuilder: (context, index) => Divider(
      //       color: Colors.grey,
      //       height: 1,
      //     ),
      itemCount: orderPagination.getOrderItems().length);

  Widget _itemsBuilder(
    BuildContext context,
    OrderItems orderItems,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed('orderDetails', arguments: orderItems),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
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
                    orderItems.item.orderId,
                    style: const TextStyle(
                        // color: Colors.white,
                        // fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              color: Colors.black26,
              height: 40,
              width: 1,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    orderItems.item.productName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Icon(Icons.person_outline,
                          size: 14, color: Colors.grey),
                    ),
                    TextSpan(
                        text: ' ' + orderItems.orderData.shippingName,
                        style: TextStyle(color: Colors.grey)),
                  ])),
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                        text: ' ' + orderItems.orderData.createdAt,
                        style: TextStyle(color: Colors.grey)),
                  ]))
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$currency ${orderItems.item.amount}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5.0, 2, 5.0, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.red),
                  child: Text(orderItems.orderData.orderStatus,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:vendor_app/helpers/constants.dart';
// import 'package:vendor_app/network/ApiCall.dart';
// import 'package:vendor_app/network/response/order_list_response.dart';

// class Orders extends StatefulWidget {
//   @override
//   _OrderState createState() => _OrderState();
// }

// class _OrderState extends State<Orders> with TickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: 6, vsync: this);
//     ApiCall().execute<OrdersListResponse, Null>('orders', null);
//   }

//   TabController _tabController;
//   TextStyle _tabTextStyle = TextStyle(
//     color: Colors.black,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders'),
//         backgroundColor: colorPrimary,
//       ),
//       body: Column(children: [
//         Container(
//             height: 40,
//             child: TabBar(
//                 controller: _tabController,
//                 unselectedLabelColor: const Color(0xffacb3bf),
//                 indicatorColor: Color(0xFFffac81),
//                 labelColor: Colors.black,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 indicatorWeight: 3.0,
//                 indicatorPadding: EdgeInsets.all(10),
//                 isScrollable: true,
//                 tabs: [
//                   Tab(
//                     text: 'New',
//                   ),
//                   Tab(
//                     text: 'Accepted',
//                   ),
//                   Tab(
//                     text: 'Under Process',
//                   ),
//                   Tab(
//                     text: 'Ready to pickup',
//                   ),
//                   Tab(
//                     text: 'Out for Delivery',
//                   ),
//                   Tab(
//                     text: 'Delivered',
//                   )
//                 ])),
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: [
//               _listview(context),
//               _listview(context),
//               _listview(context),
//               _listview(context),
//               _listview(context),
//               _listview(context),
//             ],
//           ),
//         )
//       ]),
//     );
//   }

//   Widget _listview(BuildContext context) => ListView.builder(
//       itemBuilder: (context, index) => _itemsBuilder(context, index),
//       // separatorBuilder: (context, index) => Divider(
//       //       color: Colors.grey,
//       //       height: 1,
//       //     ),
//       itemCount: 5);

//   Widget _itemsBuilder(BuildContext context, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8.0),
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(0),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             blurRadius: 3.0,
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () => Navigator.of(context).pushNamed('order'),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 50,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircleAvatar(
//                     backgroundColor: colorPrimary,
//                     child: const Text(
//                       '#id',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   Text(
//                     '1001',
//                     style: const TextStyle(
//                         // color: Colors.white,
//                         // fontSize: 14,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Container(
//               color: Colors.black26,
//               height: 40,
//               width: 1,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Product Name',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w500),
//                   ),
//                   RichText(
//                       text: TextSpan(children: [
//                     WidgetSpan(
//                       child: Icon(Icons.person_outline,
//                           size: 14, color: Colors.grey),
//                     ),
//                     TextSpan(
//                         text: ' ' + 'Customer name',
//                         style: TextStyle(color: Colors.grey)),
//                   ])),
//                   RichText(
//                       text: TextSpan(children: [
//                     WidgetSpan(
//                       child: Icon(
//                         Icons.access_time,
//                         size: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     TextSpan(
//                         text: ' ' + 'Order date and time',
//                         style: TextStyle(color: Colors.grey)),
//                   ]))
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('\$ 5000',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w400)),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Container(
//                   padding: EdgeInsets.fromLTRB(5.0, 2, 5.0, 2),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       color: Colors.red),
//                   child: Text('Pending', style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
