import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:nasa_news/ui/MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Nasa Articles Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
        //disabling the connectivity check as to give support for offline cacheing
        // builder: (buildContext, widget) {
        //   return ConnectivityWidgetWrapper(
        //     disableInteraction: false,
        //     height: 80,
        //     child: widget ?? Container(),
        //   );
        // },
      ),
    );
  }
}
