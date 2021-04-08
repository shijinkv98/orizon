import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/dashboard_response.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/products/add_new_product.dart';
import 'package:vendor_app/screens/products/lowstockproducts.dart';
import 'package:vendor_app/screens/products/outofstockproducts.dart';
import 'package:vendor_app/screens/products/pendingproducts.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'home.dart';

class Dashboard extends StatelessWidget {
  BuildContext mContext;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  // final List<SubscriberSeries> data = [
  //   SubscriberSeries(
  //     year: "Jan",
  //     subscribers: 8000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Feb",
  //     subscribers: 45000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Mar",
  //     subscribers: 4000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Apr",
  //     subscribers: 11000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "May",
  //     subscribers: 70000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Jun",
  //     subscribers: 52000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Jul",
  //     subscribers: 12000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  //   SubscriberSeries(
  //     year: "Aug",
  //     subscribers: 11000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),SubscriberSeries(
  //     year: "Sep",
  //     subscribers: 13000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),SubscriberSeries(
  //     year: "Oct",
  //     subscribers: 14000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),SubscriberSeries(
  //     year: "Nov",
  //     subscribers: 11500,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),SubscriberSeries(
  //     year: "Dec",
  //     subscribers: 51000,
  //     barColor: charts.ColorUtil.fromDartColor(Colors.blue),
  //   ),
  // ];
int tbPos=0;

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(mContext).pushReplacementNamed('home');
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    mContext=context;
    ApiCall().context=context;

    return  Scaffold(
    appBar: AppBar(
      title: Image.asset(
        'assets/logos/logo_main_small.png',
        height: 30,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    ),
    body: SmartRefresher(
      enablePullDown: true,
      child: FutureBuilder<DashboardResponse>(
        future: ApiCall().execute<DashboardResponse, Null>('dashboard', null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mStoreSlug=snapshot.data.dashboardData.storeslug;
            return _getView(context, snapshot.data.dashboardData);
          } else if (snapshot.hasError) {
            return
              // enableData();
              errorScreen('Error: ${snapshot.error}');
          } else {
            return progressBar;
          }
        },

      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,

    ),
    );
  }

  Widget _getView(BuildContext context, DashboardData dashboardData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _itemsListGradient(
                context,
                [
                  const Color(0xFF8bfcfe),
                  const Color(0xFF64a1ff),
                ],
                'New Orders',
                dashboardData.newOrderCount,
                '$currency ${dashboardData.newOrderTotal}',
                'assets/icons/new_orders.png',
                tabPosition: 1),
            _itemsListGradientP(
                context,
                [
                  const Color(0xFF82f4bb),
                  const Color(0xFF94c9e0),
                ],
                'Total Products',
                dashboardData.productsCount,

                'Pending: ${dashboardData.pending}',
                'assets/icons/total_products.png',
                dashboardData.storeslug,
                navigation: 'products',),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFf6d166),
                        const Color(0xFFfda781),
                      ],
                      'Delivered',
                      dashboardData.deliveredCount,
                      '$currency ${dashboardData.deliveredTotal}',
                      'assets/icons/delivered.png',tabPosition: 1,parameter: 'del'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFfcc88b),
                        const Color(0xFFd67fe9),
                      ],
                      'Rejected',
                      dashboardData.rejectedCount,
                      '$currency ${dashboardData.rejectedTotal}',
                      'assets/icons/rejected.png',tabPosition: 1,parameter: 'rej'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFFd1fa7a),
                        const Color(0xFF9be89d),
                      ],
                      'Return / cancelled',
                      (int.parse(dashboardData.returnedCount ?? '0') +
                              int.parse(dashboardData.cancelledCount ?? '0'))
                          .toString(),
                      '$currency ${(double.parse(dashboardData.cancelledTotal ?? '0') + double.parse(dashboardData.returnedTotal ?? '0'))}',
                      'assets/icons/return.png',tabPosition: 1,parameter:'ret'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _itemsListGradient(
                      context,
                      [
                        const Color(0xFF8dd9ea),
                        const Color(0xFF84f9b1),
                      ],
                      'Followers',
                      dashboardData.followers,
                      '',
                      'assets/icons/new_orders.png'),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Monthly Sales Chart For The Year',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 250,
              child: charts.BarChart([
                charts.Series<SalesChartData, String>(
                    id: "Subscribers",
                    data: dashboardData.salesChart,
                    domainFn: (SalesChartData series, _) => series.month,
                    measureFn: (SalesChartData series, _) =>
                        double.parse(series.amount ?? '0'),
                    colorFn: (SalesChartData series, _) =>
                        charts.ColorUtil.fromDartColor(colorPrimary))
              ], animate: true),
            ),
            SizedBox(
              height: 10,
            ),
            _itemsList(context, 'Out of stock Products',
                'assets/icons/out_of_stock.png',navigation:'outofstock_p'),
            _itemsList(context, 'Low Stock', 'assets/icons/low-atock.png',navigation:'lowstock_p'),
            _itemsList(context, 'Pending Ads to Approve',
                'assets/icons/pending.png',
                tabPosition: 0),
            _itemsList(context, 'Pending Products to Approve', 'assets/icons/pending.png',navigation:'pending_p',store: dashboardData.storeslug),
          ],
        ),
      ),
    );
  }

  Widget _itemsListGradient(
      BuildContext context,
      final List<Color>  colors,
      final String title,
      final String count,
      final String subTitle,
      final String icon,
      {final String navigation,
      final int tabPosition = -1,
      final String parameter}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          tileMode: TileMode.clamp,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: InkWell(
        onTap: () {
          if (tabPosition >= 0) {
            Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                tabPosition;
            if(parameter!=null&&parameter!="")
              {
                switch(parameter)
                {
                  case 'del':
                      tbPosition=5;
                      break;
                  case 'rej':
                    tbPosition=3;
                    break;
                  case 'ret':
                    tbPosition=4;
                    break;
                  default:
                    tbPosition=0;
                    break;
                }
              }

            else
              tbPosition=0;
          } else if (navigation != null && navigation.isNotEmpty) {
            Navigator.of(context).pushNamed(navigation);
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        count,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
                ImageIcon(
                  AssetImage(icon),
                  size: 40,
                ),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                subTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemsListGradientP(
      BuildContext context,
      final List<Color>  colors,
      final String title,
      final String count,
      final String subTitle,
      final String icon,
      final String store,
      {final String navigation,
        final int tabPosition = -1,
        final String parameter}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          tileMode: TileMode.clamp,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: InkWell(
        onTap: () {
          if (tabPosition >= 0) {
            Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                tabPosition;
            if(parameter!=null&&parameter!="")
            {
              switch(parameter)
              {
                case 'del':
                  tbPosition=5;
                  break;
                case 'rej':
                  tbPosition=3;
                  break;
                case 'ret':
                  tbPosition=4;
                  break;
                default:
                  tbPosition=0;
                  break;
              }
            }

            else
              tbPosition=0;
          }
          else if (navigation != null && navigation.isNotEmpty) {
            if(navigation=="add_product")
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddNewProduct(mStoreSlug)));
              }
            else
              Navigator.of(context).pushNamed(navigation);
          }
        },
        child: Column(


          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        count,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '+ Add Products',style:TextStyle(color:Colors.white,fontSize: 15, fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),

                ImageIcon(
                  AssetImage(icon),
                  size: 40,
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                subTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _itemsList(BuildContext context, String title, String image,
      {String navigation, int tabPosition = -1, String store}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.white,
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          if (tabPosition >= 0) {
            Provider.of<HomeTabNotifier>(context, listen: false).currentIndex =
                tabPosition;
          } else if (navigation != null && navigation.isNotEmpty) {
            if(navigation=='pending_p')
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PendingProductsScreen(store)));
              }

            else if(navigation=='lowstock_p')
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LowStockProductsScreen(store)));
            } else if(navigation=='outofstock_p')
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => OutofStockProductsScreen(store)));
            }
            else
              Navigator.of(context).pushNamed(navigation);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 15, 7),
          child: Row(
            children: [
              ImageIcon(
                AssetImage(image),
                size: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Color(0xFF828282),
              ),

            ],

          ),

        ),
      ),
    );
  }
}
