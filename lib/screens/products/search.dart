import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/custom/custom_tabview.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/screens/home/ad_manager.dart';
import 'package:vendor_app/screens/products/edit_product.dart';
import 'package:vendor_app/screens/products/search.dart';

import 'edit_product.dart';

class CustomDelegate<T> extends SearchDelegate<T> {
  List<String> data = List.generate(30, (index) => 'search $index');

  Map body={
    'by':'category'
  };



  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.chevron_left), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Container();



  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = data.where((e) => e.contains(query)).toList();
    // data.where((e) => e.contains(query) && e.startsWith(query)).toList();
    else
      listToShow = List();

    return FutureBuilder<ProductListResponse>(
      future: ApiCall()
          .execute<ProductListResponse, Null>('all-products/en',body),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('products size: ${snapshot.data?.products?.length}');
          return
            _getView(snapshot.data?.products
                ?.where((element) =>
            element.products?.data != null &&
                element.products.data.isNotEmpty)
                ?.toList());
        }
        else if (snapshot.hasError) {
          return
            // getEmptyCntainer();
            errorScreen(snapshot.error);
        }

        else {
          return progressBar;
        }
      },
    );

    //   ListView.builder(
    //   itemCount: productsPagination.data.length,
    //   itemBuilder: (_, i) {
    //     return _itemsBuilder(Product product,List<Images> images,context);
    //   },
    // );
  }
  Widget _getView(List<ProductsWithCat> productsWithCat) => CustomTabView(
    initPosition: 0,
    itemCount: productsWithCat.length,
    tabBuilder: (context, index) => Tab(text: productsWithCat[index].name),
    pageBuilder: (context, index) =>
        _listview(productsWithCat[index].products),
    onPositionChange: (index) {
      print('current position: $index');
      // initPosition = index;
    },
    onScroll: (position) => print('$position'),
  );
  Widget _listview(PaginationData productsPagination) =>
      ListView.builder(
      padding: EdgeInsets.only(bottom: 70),
      itemBuilder: (context, index) =>
          _itemsBuilder(productsPagination.data[index],productsPagination.data[index].images,context),
      // separatorBuilder: (context, index) => Divider(
      //       color: Colors.grey,
      //       height: 1,
      //     ),
      itemCount: productsPagination.data.length);


  final double _paddingTop = 8;
  final double _paddingStart = 20;
  Widget _itemsBuilder(Product product,List<Images> images,BuildContext context) {
    bool status = false;
    if(product.status==1)
      status=true;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
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
      child: Column(
        children: [
          Padding(
            padding:
            EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/no_image.png',
                  image: '$productThumbUrl${product.image}',
                  width: 65,
                  height: 65,
                ),
                SizedBox(
                  width: 5,
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
                        product.name,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('$currency ${product.currentPrice}'),
                          SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //         color: primaryTextColor,
                          //         borderRadius: BorderRadius.circular(4)),
                          //     padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                          //     child: Text(
                          //       'data',
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 12,
                          //       ),
                          //     ))
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EditProduct(product,images)));
                    })
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Padding(
            padding:
            EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
            child: Row(
              children: [
                Expanded(
                    child: double.parse(product.stock) <= 0
                        ? Text(
                      'Out of stock',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w400),
                    )
                        : RichText(
                        text: TextSpan(
                            text: 'Available Stock ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' ${product.stock}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                            ]))),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    height: 25,

                    child:CustomSwitch(
                      activeColor: colorPrimary,
                      value: status,
                      onChanged: (value) {


                        ApiCall()
                            .execute(product.productactivation, null, multipartRequest: null)
                            .then((value) {
                          String message=value['message'];
                          ApiCall().showToast(message);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) => super.widget));

                          // Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsScreen()),);

                          //ApiCall().showToast(message);

                        });
                        //print("VALUE : $value");

                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.0,),
                // Text('Active : $status', style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 20.0
                // ),)
              ],
            ),
          ),
        ],
      ),
    );
  }

// Widget _itemsBuilder(BuildContext context, int index) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 8.0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(0),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 3.0,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding:
  //               EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               FadeInImage.assetNetwork(
  //                 placeholder: 'assets/images/no_image.png',
  //                 image: 'https://picsum.photos/250?image=9',
  //                 width: 65,
  //                 height: 65,
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       'Product Name',
  //                       style: TextStyle(
  //                           color: Colors.black, fontWeight: FontWeight.w500),
  //                     ),
  //                     SizedBox(
  //                       height: 5,
  //                     ),
  //                     Row(
  //                       children: [
  //                         Text('data'),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Container(
  //                             decoration: BoxDecoration(
  //                                 color: primaryTextColor,
  //                                 borderRadius: BorderRadius.circular(4)),
  //                             padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
  //                             child: Text(
  //                               'data',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 12,
  //                               ),
  //                             ))
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               IconButton(
  //                   icon: Icon(Icons.edit_outlined),
  //                   onPressed: () {
  //                     Navigator.of(context).pushNamed('addProduct');
  //                   })
  //             ],
  //           ),
  //         ),
  //         Divider(
  //           height: 2,
  //           color: Colors.grey,
  //         ),
  //         Padding(
  //           padding:
  //               EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                   child: index % 3 == 0
  //                       ? Text(
  //                           'Out of stock',
  //                           style: TextStyle(
  //                               fontSize: 14,
  //                               color: Colors.redAccent,
  //                               fontWeight: FontWeight.w400),
  //                         )
  //                       : RichText(
  //                           text: TextSpan(
  //                               text: 'Available Stock ',
  //                               style: TextStyle(
  //                                 fontSize: 14,
  //                                 color: Colors.black54,
  //                               ),
  //                               children: <TextSpan>[
  //                               TextSpan(
  //                                   text: ' 10',
  //                                   style: TextStyle(
  //                                       color: Colors.black,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w400))
  //                             ]))),
  //               SizedBox(
  //                 height: 10,
  //                 child: Switch(
  //                   value: true,
  //                   onChanged: (value) {},
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
