import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/model/user.dart';
import 'package:vendor_app/network/ApiCall.dart';
import 'package:vendor_app/notifiers/home_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/screens/home/Maps.dart';

import 'helpers/constants.dart';
import 'map/map_places.dart';
import 'notifiers/loading_notifiers.dart';
import 'notifiers/order_details_notifier.dart';
import 'notifiers/product_notifier.dart';
import 'notifiers/register_notifier.dart';
import 'notifiers/report_notifier.dart';
import 'screens/category/category_list.dart';
import 'screens/register/login_screen.dart';
import 'screens/home/home.dart';
import 'screens/products/add_new_product.dart';
import 'screens/products/products.dart';
import 'screens/register/otp.dart';
import 'screens/register/vendor_datails.dart';
import 'screens/splash.dart';
import 'screens/register/signup_screen.dart';
import 'screens/order_details.dart';
import 'screens/subscribe_ad.dart';

String userResponse="";
void SaveUser()
async {
  var pref = await SharedPreferences.getInstance() ;
  Data data=Data(pref);
  userResponse= data.preferences.getString('user') == null ? "" : data.preferences.getString('user');

}
Future<void> main()  {
  // ignore: invalid_use_of_visible_for_testing_member

  //setupPreferences("user","");
  runApp(MyApp());
  // const MethodChannel('plugins.flutter.io/shared_preferences')
  //     .setMockMethodCallHandler((MethodCall methodCall) async {
  //   if (methodCall.method == 'getAll') {
  //     return <String, dynamic>{}; // set initial values here if desired
  //   }
  //   return null;
  // });

}
Future setupPreferences(String key, String value) async {
  SharedPreferences.setMockInitialValues(<String, dynamic>{'flutter.' + key: value});
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, value);
}
class Data {
  SharedPreferences preferences;
  Data(this.preferences);
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ApiCall().context = context;
    return MultiProvider(
      providers: [

         ChangeNotifierProvider(
          create: (context) => HomeTabNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckBoxNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OTPNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageAddedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DocsAddedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhysicalStoreClickNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardLoadNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportLoadingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderDetailsLoadingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderTimelineNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategorySelectedNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddProductLoadingNotifier(),
        ),
        ChangeNotifierProvider.value(value: GenerateMaps(),
        ),


        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => DocsAddedNotifier(),
        // ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'splash':
              return MaterialPageRoute(builder: (_) => SplashScreen());
              break;
            case 'login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
              break;
            case 'signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
              break;
            case 'home':
              return MaterialPageRoute(builder: (_) => HomeScreen());
              break;
            case 'orderDetails':
              return MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(
                        orderItems: settings.arguments,
                      ));
              break;
            case 'categories':
              return MaterialPageRoute(builder: (_) => CategoryListScreen());
              break;
            case 'products':
              return MaterialPageRoute(builder: (_) => ProductsScreen());
              break;
            // case 'subscribeAds':
            //   return MaterialPageRoute(builder: (_) => SubscribeAds());
            //   break;
            case 'addProduct':
              return MaterialPageRoute(builder: (_) => AddNewProduct(""));
              break;
            case 'vendorDetails':
              return MaterialPageRoute(
                  builder: (_) => VendorDetailScreen(
                        userData: settings.arguments,
                      ));
              break;
            case 'otp':
              return MaterialPageRoute(
                  builder: (_) => OtpScreen(
                        userData: settings.arguments,
                      ));
              break;
            case 'mapPlacePicker':
              return MaterialPageRoute(builder: (_) => MapPlacePicker());
              break;
            // case 'prod':
            //   return MaterialPageRoute(builder: (_) => SearchProduct());
            //   break;
            // case 'prod':
            //   return MaterialPageRoute(builder: (_) => SearchProduct());
            //   break;
            // case 'prod':
            //   return MaterialPageRoute(builder: (_) => SearchProduct());
            //   break;
            default:
              return MaterialPageRoute(builder: (_) => SplashScreen());
              break;
          }
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: colorPrimary,
          fontFamily: 'Roboto',
          // primarySwatch: colorPrimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
