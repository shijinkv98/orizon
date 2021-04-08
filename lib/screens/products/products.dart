import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/custom/custom_tabview.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/screens/products/edit_product.dart';
import 'package:vendor_app/screens/products/search.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  final double _paddingTop = 8;
  final double _paddingStart = 20;
  @override
  void initState() {
    super.initState();
    // ApiCall().execute<ProductListResponse, Null>('all-products/en', null);
  }

  @override
  Widget build(BuildContext context) {
    Map body={
      'by':'category'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: colorPrimary,
        automaticallyImplyLeading: false,
        leading:IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("home");

            })

        ,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                // Navigator.of(context).pushNamed('searchProduct');
              })
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: colorPrimary,
        onPressed: () {
          Navigator.of(context).pushNamed('addProduct');
        },
      ),
      body:
      FutureBuilder<ProductListResponse>(
        future: ApiCall()
            .execute<ProductListResponse, Null>('all-products/en', body),
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
      ),
    );
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

  Widget _listview(PaginationData productsPagination) => ListView.builder(
      padding: EdgeInsets.only(bottom: 70),
      itemBuilder: (context, index) =>
          _itemsBuilder(productsPagination.data[index],productsPagination.data[index].images),
      // separatorBuilder: (context, index) => Divider(
      //       color: Colors.grey,
      //       height: 1,
      //     ),
      itemCount: productsPagination.data.length);
  Widget getEmptyCntainer()
  {
    return Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text('Add Your First Product',style: TextStyle(fontSize: 20  , color: primaryTextColor),),
            ),
          ],
        )
    );
  }
  Widget _itemsBuilder(Product product,List<Images> images) {
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
                    }),
                Container(
                  margin: EdgeInsets.only(top: 2,right: 10),
                  width: 25,
                  padding: EdgeInsets.all(2),
                  child:
                  InkWell(
                      onTap: ()
                      async {
                        showAlertDeleteProduct( product.productId.toString());


                      },
                      child: Image.asset('assets/icons/trash.png',color: Colors.black,fit: BoxFit.fitWidth)),

                )
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
                            text:'Available Stock',
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
                          setState(() {

                          });
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
  void showAlertDeleteProduct(String productId){


    showDialog(

      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are you sure you want to delete?"),
        // content: Text("See products pending for approval"),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL"),
              ),
              FlatButton(
                onPressed: () {
                  Map body = {
                    'product_id': productId,
                  };

                  ApiCall()
                      .qpprove_reject(
                    '${"deleteproduct/"}${productId}',
                    null,
                  )
                      .then((value) {

                    String message = value['message'];
                    Navigator.of(context).pop();
                    setState(() {

                    });
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PendingProductsScreen(mStoreSlug)),
                    // );
                  });
                },
                child: Text("DELETE"),
              ),

            ],
          ),
        ],
      ),
    );
  }

}
//
// class ProductsScreen extends StatefulWidget {
//   @override
//   _ProductsState createState() => _ProductsState();
// }
//
// class _ProductsState extends State<ProductsScreen>
//     with TickerProviderStateMixin {
//   final double _paddingTop = 8;
//   final double _paddingStart = 20;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: 6, vsync: this);
//     ApiCall().execute('view-product', {});
//   }
//
//   TabController _tabController;
//   TextStyle _tabTextStyle = TextStyle(
//     color: Colors.black,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//         backgroundColor: colorPrimary,
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 showSearch<String>(
//                   context: context,
//                   delegate: CustomDelegate(),
//                 );
//                 // Navigator.of(context).pushNamed('searchProduct');
//               })
//         ],
//         elevation: 0,
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.add,
//           size: 30,
//         ),
//         backgroundColor: colorPrimary,
//         onPressed: () {
//           Navigator.of(context).pushNamed('addProduct');
//         },
//       ),
//       body: Column(children: [
//         Container(
//             height: 40,
//             color: colorPrimary,
//             child: TabBar(
//                 controller: _tabController,
//                 unselectedLabelColor: Colors.white70,
//                 indicatorColor: Colors.white,
//                 labelColor: Colors.white,
//                 indicatorSize: TabBarIndicatorSize.label,
//                 indicatorWeight: 1.0,
//                 indicatorPadding: EdgeInsets.all(5),
//                 isScrollable: true,
//                 tabs: [
//                   Tab(
//                     text: 'Categor 1',
//                   ),
//                   Tab(
//                     text: 'Categor 2',
//                   ),
//                   Tab(
//                     text: 'Categor 3',
//                   ),
//                   Tab(
//                     text: 'Categor 4',
//                   ),
//                   Tab(
//                     text: 'Categor 5',
//                   ),
//                   Tab(
//                     text: 'Categor 6',
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
//
//   Widget _listview(BuildContext context) => ListView.builder(
//       padding: EdgeInsets.only(bottom: 70),
//       itemBuilder: (context, index) => _itemsBuilder(context, index),
//       // separatorBuilder: (context, index) => Divider(
//       //       color: Colors.grey,
//       //       height: 1,
//       //     ),
//       itemCount: 5);
//
//   Widget _itemsBuilder(BuildContext context, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8.0),
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
//       child: Column(
//         children: [
//           Padding(
//             padding:
//                 EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FadeInImage.assetNetwork(
//                   placeholder: 'assets/images/no_image.png',
//                   image: 'https://picsum.photos/250?image=9',
//                   width: 65,
//                   height: 65,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Product Name',
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Row(
//                         children: [
//                           Text('data'),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                               decoration: BoxDecoration(
//                                   color: primaryTextColor,
//                                   borderRadius: BorderRadius.circular(4)),
//                               padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
//                               child: Text(
//                                 'data',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                               ))
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                     icon: Icon(Icons.edit_outlined),
//                     onPressed: () {
//                       Navigator.of(context).pushNamed('addProduct');
//                     })
//               ],
//             ),
//           ),
//           Divider(
//             height: 2,
//             color: Colors.grey,
//           ),
//           Padding(
//             padding:
//                 EdgeInsets.fromLTRB(_paddingStart, _paddingTop, 0, _paddingTop),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: index % 3 == 0
//                         ? Text(
//                             'Out of stock',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.redAccent,
//                                 fontWeight: FontWeight.w400),
//                           )
//                         : RichText(
//                             text: TextSpan(
//                                 text: 'Available Stock ',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black54,
//                                 ),
//                                 children: <TextSpan>[
//                                 TextSpan(
//                                     text: ' 10',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400))
//                               ]))),
//                 SizedBox(
//                   height: 10,
//                   child: Switch(
//                     value: true,
//                     onChanged: (value) {},
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
