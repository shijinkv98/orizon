import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductsScreen2 extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

TextStyle _optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class _ProductsState extends State<ProductsScreen2>
    with TickerProviderStateMixin {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      // setState(() {
      //   _selectedIndex = _controller.index;
      // });
      _itemScrollController.scrollTo(
          index: _tabController.index, duration: Duration(milliseconds: 300));
      print("Selected Index: " + _tabController.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Products'),
            backgroundColor: colorPrimary,
          ),
          body: Column(children: [
            Container(
                height: 40,
                child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: const Color(0xffacb3bf),
                    indicatorColor: const Color(0xFFffac81),
                    labelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3.0,
                    indicatorPadding: const EdgeInsets.all(10),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: 'New',
                      ),
                      Tab(
                        text: 'Accepted',
                      ),
                      Tab(
                        text: 'Under Process',
                      ),
                      Tab(
                        text: 'Ready to pickup',
                      ),
                      Tab(
                        text: 'Out for Delivery',
                      ),
                      Tab(
                        text: 'Delivered',
                      )
                    ])),
            Expanded(
              child: ScrollablePositionedList.separated(
                  itemPositionsListener: _itemPositionsListener,
                  itemScrollController: _itemScrollController,
                  itemBuilder: (context, index) => _itemBuilder(context, index),
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                  itemCount: 15),
            )
          ]),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Name - ${index + 1}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          ListView.separated(
              itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grocery'),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                      )
                    ],
                  ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
              itemCount: 5),
        ],
      ),
    );
  }
}
