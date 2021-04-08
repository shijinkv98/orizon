import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

TextStyle _optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class _CategoryListState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Categories'),
            backgroundColor: colorPrimary,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        _itemBuilder(context, index),
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                    itemCount: 15),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Text('Add'),
          ),
        );
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('data'),
          Switch(
            value: true,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
