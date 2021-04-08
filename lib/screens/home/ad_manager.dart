import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/entities/note.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/network/response/SubscribeResponse.dart';
import 'package:vendor_app/screens/home/cropeImage.dart';
import 'package:vendor_app/screens/register/testList.dart';
import 'package:uuid/uuid.dart';
import 'package:vendor_app/screens/subscribe_ad.dart';

import '../UploadImageDemo2.dart';
import 'home.dart';

class AdManager extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}
int index_selected=0;


class _ProductsState extends State<AdManager> with TickerProviderStateMixin {
  final double _paddingTop = 8;
  final double _paddingStart = 20;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    // ApiCall().execute('', null);
    // fetchNotes().then((value){
    setState(() {
      // _notes.addAll(value);
    });
    // });
    // this.fetchUser();
  }

  // fetchUser() async {
  //
  //  if (response.statusCode == 200) {
  //    var items = json.decode(response.body);
  //    setState(() {
  //      users = items;
  //    });
  //  } else {
  //    setState(() {
  //      users = [];
  //    });
  //  }
  // }

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

  // static const FROM_ALL_ADS="FROM_ALL_ADS";
  // static const FROM_ONGOING="FROM_ONGOING";
  // static const FROM_HISTORY="FROM_HISTORY";
  Future<List<GetUsers>> fetchJSONData() async {
    // String FROM
    var user = await getUser();
    Data data = Data(user);
    index_selected=0;
    userId = data.user.id;
    userToken = data.user.token;
    String url = apiURL + "?id=" + userId + "&token=" + userToken;
    //var jsonResponse = await http.get(url);
    // var url = apiURL +
    //     "?id=" +
    //     getUserId().toString() +
    //     "&token=" +
    //     getUserToken().toString();
    // switch(FROM)
    // {
    //   case FROM_ALL_ADS:
    //     {
    //       url = apiURL + "?id=" + getUserId().toString() + "&token=" +
    //           getUserToken().toString();
    //     }
    //     break;
    //   case FROM_ONGOING:
    //     {
    //       url = apiURL1 + "?id=" + getUserId().toString() + "&token=" +
    //           getUserToken().toString();
    //     }
    //     break;
    //   case FROM_HISTORY:
    //     {
    //       url = apiURL + "?id=" + getUserId().toString() + "&token=" +
    //           getUserToken().toString();
    //     }
    //     break;
    // }
    // var url=apiURL+"?id="+getUserId().toString()+"&token="+getUserToken().toString();
    // var url1=apiURL1+"?id="+getUserId().toString()+"&token="+getUserToken().toString()
    var jsonResponse = await http.get(url);

    if (jsonResponse.statusCode == 200) {
      var object=json.decode(jsonResponse.body);
      List<Payments> payments=new List<Payments>();
      var payArray=object['payments'];
      if(payArray!=null)
        {
          if(payArray.length!=0)
            {
              String paid=payArray[0]['paid'].toString();
              String due=payArray[0]['due'].toString();
              if(paid==null||paid=="null")
                paid="0.0";
              if(due==null||due=="null")
                due="0.0";
              payment=new Payments(paid: paid,due: due);
            }
          else
            payment=new Payments(paid: "0.00",due: "0.00");
        }
      else
        payment=new Payments(paid: "0.00",due: "0.00");

      final jsonItems =
      object['admanager'];
      List<GetUsers> usersList=new List<GetUsers>();
      for(int i=0;i<jsonItems.length;i++)
        {
          var item =jsonItems[i];
          int id = item['id'];
          String price = item['price'].toString();
          String title = item['title'];
          String description = item['description'];
          String url = item['url'];
          usersList.add(new GetUsers(id:id,price: price,title: title,description: description,url: url));
        }
      // List<GetUsers> usersList = jsonItems.map<GetUsers>((json) {
      //   return GetUsers.fromJson(json);
      // }).toList();

      return usersList;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }


  Future<List<GetUsers1>> fetchJSONData1() async {
    var url1 = apiURL1 +
        "?id=" +
        getUserId().toString() +
        "&token=" +
        getUserToken().toString();
    var jsonResponse1 = await http.get(url1);
    if (jsonResponse1.statusCode == 200) {
      final jsonItems =
      json.decode(jsonResponse1.body).cast<Map<String, dynamic>>();

      List<GetUsers1> usersList1 = jsonItems.map<GetUsers>((json) {
        return GetUsers1.fromJson(json);
      }).toList();

      return usersList1;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }
  //   Future<List<Payments>> fetchJSONPayments() async {
  //     var url1 = apiURL +
  //         "?id=" +
  //         getUserId().toString() +
  //         "&token=" +
  //         getUserToken().toString();
  //     var jsonResponsePayments = await http.get(url1);
  //     if (jsonResponsePayments.statusCode == 200) {
  //       final jsonItems =
  //       json.decode(jsonResponsePayments.body).cast<Map<String, dynamic>>();
  //
  //       List<Payments> usersPayments = jsonItems.map<Payments>((json) {
  //         return Payments.fromJson(json);
  //       }).toList();
  //
  //       return usersPayments;
  //     } else {
  //       throw Exception('Failed to load data from internet');
  //     }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Ad Manager')),
        backgroundColor: colorPrimary,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<GetUsers>>(
          future: fetchJSONData(),
          builder: (context, snapshot) {
        if (!snapshot.hasData)
        return Center(child: CircularProgressIndicator());
        return Column(children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4,color: Colors.white),

                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                    padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
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
                            Text('${"QAR "}${payment.paid}',

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
                              '${"QAR "}${payment.due}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 40,
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryTextColor,
                  labelColor: primaryTextColor,
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
                JSONListView(),
                JSONListView1(),
                JSONListView2(),
              ],
            ),
          )
        ]);
      }
      )
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
        // Padding(
        //   padding: const EdgeInsets.all(15),
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     primary: false,
        //     itemBuilder: (context, index) {
        //       if (position == 0) {
        //         return JSONListView();
        //       } else if (position == 1) {
        //         return _itemsBuilder2(context, index);
        //       } else {
        //         return _itemsBuilder3(context, index);
        //       }
        //     },
        //     // separatorBuilder: (context, index) => Divider(
        //     //       color: Colors.grey,
        //     //       height: 1,
        //     //     ),
        //     // itemCount: 5,
        //   ),
        // )
      ],
    ),
  );

// Widget _itemsBuilder1(int index) {
//
//
//   return Card(
//     margin: const EdgeInsets.only(bottom: 8.0),
//     elevation: 3,
//     color: const Color(0xFFf2f5fe),
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//
//          Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                    'title',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text
//                   ('Subtitle',
//                   //_notes[index].subtitle,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w300),
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Row(
//                   children: [
//                     Text('Price',
//                      // _notes[index].price,
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text('validity',
//                       // _notes[index].validity,
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const Icon(Icons.play_circle_outline,
//               size: 30, color: colorPrimary),
//           SizedBox(width: 8),
//           SizedBox(
//             height: 25,
//             child: RaisedButton(
//               color: colorPrimary,
//               padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//               textColor: Colors.white,
//               child: Row(
//                 children: const [
//                   const Text(
//                     'Subscribe ',
//                     style: TextStyle(
//                       fontSize: 13,
//                     ),
//                   ),
//                   const Icon(
//                     Icons.add,
//                     size: 15,
//                   ),
//                 ],
//               ),
//               onPressed: () {
//                 Navigator.of(context).pushNamed('subscribeAds');
//               },
//             ),
//           )
//         ],
//       ),
//     ),
//   );
//
// }
// Widget _itemsBuilder2(BuildContext context, int index) {
//   return Card(
//     margin: const EdgeInsets.only(bottom: 8.0),
//     elevation: 3,
//     color: const Color(0xFFf2f5fe),
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Promotion banner',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   'small desc',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w300),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           Text(
//             '10 days left ',
//             style: TextStyle(fontSize: 12, color: Colors.red),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//   Widget _itemsBuilder3(BuildContext context, int index) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8.0),
//       elevation: 3,
//       color: const Color(0xFFf2f5fe),
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Promotion banner',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   Text(
//                     'small desc',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w300),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 7,
//             ),
//             Text(
//               'QAR 10.00 ',
//               style: TextStyle(fontSize: 12, color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}

class GetUsers {
  int id;
  String title;
  String description;
  String price;
  String url;
//List<Payments> payments;


  GetUsers({this.id, this.title, this.description, this.price, this.url});

  factory GetUsers.fromJson(Map<String, dynamic> json) {
    // List<Payments> payments=new List<Payments>();
    // if (json['payments'] != null) {
    //
    //   json['payments'].forEach((v) {
    //     payments.add(new Payments.fromJson(v));
    //   });
    // }
    return GetUsers(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        url: json['url']
    );

  }
}
class Payments
{
  String paid;
  String due;
  Payments({this.paid, this.due});
  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      paid: json['paid'],
      due: json['due']);
  }



}
class GetUsers1 {
  int id;
  String title;
  String description;
  String date;
  String url;

  GetUsers1({this.id, this.title, this.description, this.date});

  factory GetUsers1.fromJson(Map<String, dynamic> json) {
    return GetUsers1(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: json['price']);
  }
}

class GetUsers2 {
  int id;
  String title;
  String description;
  String date;

  GetUsers2({this.id, this.title, this.description, this.date});

  factory GetUsers2.fromJson(Map<String, dynamic> json) {
    return GetUsers2(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: json['price']);
  }
}

class JSONListView extends StatefulWidget {
  CustomJSONListView createState() => CustomJSONListView();
}
Payments payment;

class CustomJSONListView extends State {
  final String apiURL = 'http://xshop.alisonsdemo.tk/api/admanagerlist';
  var uuid = Uuid();

  Future<List<GetUsers>> fetchJSONData() async {
    var user = await getUser();
    Data data = Data(user);
    index_selected=0;
    userId = data.user.id;
    userToken = data.user.token;
    String url = apiURL + "?id=" + userId + "&token=" + userToken;
    var jsonResponse = await http.get(url);
    String body = jsonResponse.body;
    if (jsonResponse.statusCode == 200) {
      var item=json.decode(jsonResponse.body);
      final jsonItems =item['admanager'];

      List<GetUsers> usersList = List<GetUsers>();

      for (int i = 0; i < jsonItems.length; i++) {
        var item = jsonItems[i];
        int id = item['id'];
        String price = item['price'].toString();
        String title = item['title'];
        String description = item['description'];
        String url = item['url'];
          //   var validity=item['validity'];
        GetUsers user = new GetUsers(
            id: id, title: title, description: description, price: price,url:url);
        usersList.add(user);
      }
      // List<GetUsers> usersList = jsonItems.map<GetUsers>((json) {
      //   return GetUsers.fromJson(json);
      // }).toList();

      return usersList;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }
  Future<void> _launchUniversalLinkIos(String url) async{
    if(await canLaunch(url)){
      final bool nativeAppLaunchSucceeded = await launch(url,forceSafariVC: false,universalLinksOnly: true,);
      if (!nativeAppLaunchSucceeded){
        await launch(url,forceSafariVC: true);
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GetUsers>>(
        future: fetchJSONData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(


            children: snapshot.data
                .map(
                  (user) => Card(
                margin: const EdgeInsets.only(
                    top: 5, right: 15, left: 15, bottom: 5.0),
                elevation: 3,
                color: const Color(0xFFFFFFFF),
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
                              user.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              user.description,
                              //_notes[index].subtitle,
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
                                  user.price,
                                  // _notes[index].price,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'validity',
                                  // _notes[index].validity,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.play_circle_outline,
                          size: 30, color: colorPrimary,),
                          onPressed:(){
                          _launchUniversalLinkIos(user.url);
                          }

                      ),
                      SizedBox(width: 8),
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
                          onPressed: () async {
                           adMangerId = user.id.toString();

                            Map body = {
                              'id': userId,
                              'token': userToken,
                              'ad_manager_id': adMangerId,
                            };

                ApiCall()
                    .executeAdmanager('ad-subscribe', body, multipartRequest: null)
                    .then((value) {
                      String message=value['message'];
                      if(message!="Already Subscribed")
                        {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => UploadImageDemo2()),);
                        }
                      ApiCall().showToast(message);

                });
                            }
                            // String value = await ApiCall()
                            //     .executeAdmanager<String, Null>(
                            //     "ad-subscribe", body);
                            // if (value != null) {
                            //   Navigator.push(context,MaterialPageRoute(builder: (context) => SubscribeAds()),);                                }
                            //
                            // Navigator.of(context).pushNamed(
                            //     'subscribeAds');

                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }
}

class JSONListView1 extends StatefulWidget {
  CustomJSONListView1 createState() => CustomJSONListView1();
}

Future<UserData> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') == null ? "" : prefs.getString('user');
  if (user == null || user.trim().isEmpty) {
    return null;
  }
  return UserData.fromJson(json.decode(user == null ? "" : user));
}

class Data {
  UserData user;

  Data(this.user);
}

String userId = "", userToken = "";

class CustomJSONListView1 extends State {
  final String apiURL = 'http://xshop.alisonsdemo.tk/api/ongoing';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GetUsers1>>(
        future: fetchJSONData1(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data
                .map(
                  (user1) => Card(
                margin: const EdgeInsets.only(
                    top: 5, right: 15, left: 15, bottom: 5.0),
                elevation: 3,
                color: const Color(0xFFFFFFFF),
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
                              user1.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              user1.description,
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
                        user1.date,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                      Text('days left',
                          style:
                          TextStyle(fontSize: 12, color: Colors.red)),
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }
}

class JSONListView2 extends StatefulWidget {
  CustomJSONListView2 createState() => CustomJSONListView2();
}

// Future<UserData> getUser() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String user = prefs.getString('user') == null ? "" : prefs.getString('user');
//   if (user == null || user.trim().isEmpty) {
//     return null;
//   }
//   return UserData.fromJson(json.decode(user == null ? "" : user));
// }
//
// class Data {
//   UserData user;
//
//   Data(this.user);
// }
// String userId="",userToken="";
class CustomJSONListView2 extends State {
  final String apiURL = 'http://xshop.alisonsdemo.tk/api/history';

  Future<List<GetUsers2>> fetchJSONData2() async {
    String url = apiURL + "?id=" + userId + "&token=" + userToken;
    var jsonResponse = await http.get(url);

    if (jsonResponse.statusCode == 200) {
      var jsonString = jsonResponse.body;
      Map<String, dynamic> user = jsonDecode(jsonResponse.body);
      final jsonItems = user['history'];
      // ignore: deprecated_member_use
      List<GetUsers2> usersList2 = List<GetUsers2>();
      for (int i = 0; i < jsonItems.length; i++) {
        var item = jsonItems[i];
        int id = item['id'];
        String date = item['date'].toString();
        String title = item['title'];
        String description = item['description'];
        //   var validity=item['validity'];
        GetUsers2 user2 = new GetUsers2(
            id: id, title: title, description: description, date: date);
        usersList2.add(user2);
      }
      // List<GetUsers> usersList = jsonItems.map<GetUsers>((json) {
      //   return GetUsers.fromJson(json);
      // }).toList();

      return usersList2;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GetUsers2>>(
        future: fetchJSONData2(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data
                .map(
                  (user2) => Card(
                margin: const EdgeInsets.only(
                    top: 5, right: 15, left: 15, bottom: 5.0),
                elevation: 3,
                color: const Color(0xFFFFFFFF),
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
                              user2.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              user2.description,
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
                      Text('Expired on:',
                          style:
                          TextStyle(fontSize: 12, color: Colors.red)),
                      Text(
                        user2.date,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            )
                .toList(),
          );
        },
      ),
    );
  }
}
