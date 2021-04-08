
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/helpers/constants.dart';

void main() => runApp(testList());

class testList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
              child: JSONListView()
          ),
        ));
  }
}

class GetUsers {
  int id;
  String title;
  String description;
  String price;

  GetUsers({
    this.id,
    this.title,
    this.description,
    this.price
  });

  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price']
    );
  }
}

class JSONListView extends StatefulWidget {
  CustomJSONListView createState() => CustomJSONListView();
}

class CustomJSONListView extends State {

  final String apiURL = 'http://xshop.alisonsdemo.tk/api/admanagerlist';
  Future<List<GetUsers>> fetchJSONData() async {

    var jsonResponse = await http.get(apiURL);

    if (jsonResponse.statusCode == 200) {

      final jsonItems = json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
      List<GetUsers> usersList=List<GetUsers>();
      for(int i=0;i<jsonItems.length;i++)
       {
         var item=jsonItems[i];
          int id=item['id'];
         String price=item['price'].toString();
         String title=item['title'];
         String description=item['description'];
      //   var validity=item['validity'];
         GetUsers user=new GetUsers(id:id,title: title,description: description,price: price);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON ListView in Flutter'),
      ),
      body: FutureBuilder<List<GetUsers>>(
        future: fetchJSONData(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((user) => Card(
              margin: const EdgeInsets.only(top:5,right:15,left:15,bottom: 5.0),
              elevation: 3,
              color: const Color(0xFFf2f5fe),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [


                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user.title,
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text
                                (user.description,
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
                                  Text(user.price,
                                    // _notes[index].price,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('validity',
                                    // _notes[index].validity,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.play_circle_outline,
                        size: 30, color: colorPrimary),
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
                        onPressed: () {
                          Navigator.of(context).pushNamed('subscribeAds');
                        },
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