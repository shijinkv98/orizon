import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/custom/custom_tabview.dart';
import 'package:vendor_app/helpers/constants.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/network/response/pending_product_list_response.dart';
import 'package:vendor_app/network/response/product_list_response.dart';
import 'package:vendor_app/screens/home/home.dart';
import 'package:vendor_app/screens/products/search.dart';

import 'edit_product.dart';

class PendingProductsScreen extends StatefulWidget {
  String store;
  @override
  _PendingProductsScreenState createState() =>
      _PendingProductsScreenState(store: this.store);
  PendingProductsScreen(String response) {
    this.store = response;
  }
}

class _PendingProductsScreenState extends State<PendingProductsScreen>
    with TickerProviderStateMixin {
  final double _paddingTop = 8;
  final double _paddingStart = 20;
  String store = "";
  _PendingProductsScreenState({this.store});
  @override
  void initState() {
    super.initState();

    // ApiCall().execute<ProductListResponse, Null>('pendingproducts', null);
  }

  @override
  Widget build(BuildContext context) {
    Map body = {
      'store': store,
    };

    return WillPopScope(
        onWillPop: () async => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('Are you sure you want to quit?'),
                    actions: <Widget>[
                      RaisedButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(context).pop(true)),
                      RaisedButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false)),
                    ])),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pending Products'),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()))),
            backgroundColor: colorPrimary,
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
          body: FutureBuilder<PendingProductResponse>(
            future: ApiCall()
                .execute<PendingProductResponse, Null>('pendingproducts', body),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint('products size: ${snapshot.data?.product?.length}');
                return _listview(snapshot.data?.product
                    ?.where((element) => element != null)
                    ?.toList());
              } else if (snapshot.hasError) {
                return errorScreen('Error: ${snapshot.error}');
              } else {
                return progressBar;
              }
            },
          ),
        ));
  }

  Widget _getView(List<Product> productsWithCat) => CustomTabView(
        initPosition: 0,
        itemCount: productsWithCat.length,
        tabBuilder: (context, index) => Tab(text: productsWithCat[index].name),
        pageBuilder: (context, index) => _listview(productsWithCat),
        onPositionChange: (index) {
          print('current position: $index');
          // initPosition = index;
        },
        onScroll: (position) => print('$position'),
      );

  Widget _listview(List<Product> productsPagination) => ListView.builder(
      padding: EdgeInsets.only(bottom: 70),
      itemBuilder: (context, index) => _itemsBuilder(productsPagination[index]),
      // separatorBuilder: (context, index) => Divider(
      //       color: Colors.grey,
      //       height: 1,
      //     ),
      itemCount: productsPagination.length);

  Widget _itemsBuilder(Product product) {
    bool status = false;
    if (product.status == 1) status = true;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(product.currentPrice != null
                              ? '${product.symbolLeft}${" "} ${product.currentPrice}'
                              : ""),
                          SizedBox(
                            width: 10,
                          ),

                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.yellow,
                        ),

                        child: Text(product.rejectionNote,style: TextStyle(color: Colors.red,fontSize: 12,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 10),
                        height: 30,
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(4)),
                        child: InkWell(
                          onTap: (){

                            ApiCall()
                                .qpprove_reject(
                              '${"updateproduct/"}${product.productId}',
                              null,
                            )
                                .then((value) {

                              String message = value['message'];

                              setState(() {

                              });
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => PendingProductsScreen(mStoreSlug)),
                              // );
                            });

                          },
                          child: Text(
                            'Resend for Review',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,right: 0),
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 2,right: 10),

                              width: 25,
                              padding: EdgeInsets.all(2),
                              child:InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => EditProduct(product,product.images)));

                                  },
                                  child: Image.asset('assets/icons/edit2.png',color:colorPrimary,fit: BoxFit.fitWidth,)),

                              ),
                            SizedBox(width: 10,),
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
                                  child: Image.asset('assets/icons/trash.png',color: colorPrimary,fit: BoxFit.fitWidth)),

                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
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
