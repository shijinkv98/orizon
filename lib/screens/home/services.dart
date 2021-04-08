import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/screens/home/ad_manager.dart';


class AdManager2 extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<AdManager> with TickerProviderStateMixin {
  final double _paddingTop = 8;
  final double _paddingStart = 20;
  final String apiURL2 = 'http://xshop.alisonsdemo.tk/api/ongoing';

  Future<List<GetUsers1>> fetchJSONData1() async {
    String url = apiURL + "?id=" + userId + "&token=" + userToken;
    var jsonResponse = await http.get(url);

    if (jsonResponse.statusCode == 200) {
      var jsonString = jsonResponse.body;
      Map<String, dynamic> user = jsonDecode(jsonResponse.body);
      final jsonItems = user['ongoing'];
      // ignore: deprecated_member_use
      List<GetUsers1> usersList1 = List<GetUsers1>();
      for (int i = 0; i < jsonItems.length; i++) {
        var item = jsonItems[i];
        int id = item['id'];
        String date = item['date'].toString();
        String title = item['title'];
        String description = item['description'];
        //   var validity=item['validity'];
        GetUsers1 user1 = new GetUsers1(
            id: id, title: title, description: description, date: date);
        usersList1.add(user1);
      }
      // List<GetUsers> usersList = jsonItems.map<GetUsers>((json) {
      //   return GetUsers.fromJson(json);
      // }).toList();

      return usersList1;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    ApiCall().execute('dashboard', null);
  }

  TabController _tabController;
  TextStyle _tabTextStyle = TextStyle(
    color: Colors.black,
  );
  final String apiURL = 'http://xshop.alisonsdemo.tk/api/admanagerlist';
  final String apiURL1 = 'http://xshop.alisonsdemo.tk/api/ongoing';
  Future<String> getUserToken() async {
    String token;
    var user = await ApiCall().getUser();
    if (user != null && user.token != null && user.token.trim().isNotEmpty) {
      token = user.token;
    }
    return token;
  }

  Future<String> getUserId() async {
    String id;
    var user = await ApiCall().getUser();
    if (user != null && user.id != null && user.id.trim().isNotEmpty) {
      id = user.id;
    }
    return id;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Manager'),
        backgroundColor: colorPrimary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
            height: 40,
            color: colorPrimary,
            child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 1.0,
                indicatorPadding: EdgeInsets.all(5),
                tabs: [
                  Tab(
                    text: 'All Ads',
                  ),
                  Tab(
                    text: 'Ongoing',
                  ),
                  Tab(
                    text: 'History',
                  ),
                ])),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _listview(context, 0),
              _listview(context, 1),
              _listview(context, 2),
            ],
          ),
        )
      ]),
    );
  }

  Widget _listview(BuildContext context, int position) => SingleChildScrollView(
    child: Column(
      children: [
        Container(
          color: const Color(0xFFf5f5f5), //
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            color: primaryTextColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          'TOTAL PAID',
                          style: TextStyle(color: Colors.white),
                        )),
                    Text(
                      ' QAR 150.00',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          'DUE PAYMENT',
                          style: TextStyle(color: Colors.white),
                        )),
                    Text(
                      ' QAR 150.00',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                if (position == 0) {
                  return _itemsBuilder1(index);
                } else if (position == 1) {
                  return _itemsBuilder2(context, index);
                } else {
                  return _itemsBuilder3(context, index);
                }
              },
              // separatorBuilder: (context, index) => Divider(
              //       color: Colors.grey,
              //       height: 1,
              //     ),
              itemCount: 10),
        ),
      ],
    ),
  );


  Widget _itemsBuilder1(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 3,
      color: const Color(0xFFf2f5fe),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'small desc',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        'data',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '20 days',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
              child: RaisedButton(
                color: colorPrimary,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                textColor: Colors.white,
                child: Row(
                  children: const [
                    const Text(
                      'Subscribe ',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('subscribeAds');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemsBuilder2(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 3,
      color: const Color(0xFFf2f5fe),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Promotion banner',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'small desc',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              '10 days left ',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemsBuilder3(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 3,
      color: const Color(0xFFf2f5fe),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Promotion banner',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'small desc',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              'QAR 10.00 ',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class GetUsers1 {
  int id;
  String title;
  String description;
  String date;

  GetUsers1({this.id, this.title, this.description, this.date});

  factory GetUsers1.fromJson(Map<String, dynamic> json) {
    return GetUsers1(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: json['price']);
  }
}
