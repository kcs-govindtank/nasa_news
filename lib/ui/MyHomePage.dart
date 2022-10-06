import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa_news/constants/TextStyles.dart';

import '../model/Article.dart';
import '../network/HttpService.dart';
import 'DetailScreen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Flutter - API Implementation"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Icon(Icons.cancel),
        backgroundColor: Colors.green,
      ),
    );
  }

  // build list view & manage states
  FutureBuilder<List<Item>> _buildBody(BuildContext context) {
    final HttpService httpService = HttpService();
    return FutureBuilder<List<Item>>(
      future: httpService.getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Item> articles = snapshot.requireData;
          return _buildArticles(context, articles);
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // build list view & its tile
  ListView _buildArticles(BuildContext context, List<Item> articles) {
    return ListView.builder(
      itemCount: articles.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: ListBody(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(),
                        settings: RouteSettings(arguments: articles[index])),
                  );
                },
                child: Table(
                  columnWidths: const {1: FlexColumnWidth(1.8)},
                  children: [
                    TableRow(children: [
                      InkWell(
                        child: SizedBox(
                            width: 50.0,
                            height: 100.0,
                            child: Image.network(
                              articles[index].links != null &&
                                      articles[index].links.isNotEmpty
                                  ? articles[index].links.first.href.toString()
                                  : "",
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                print("Exception >> ${exception.toString()}");
                                return Image.asset(
                                    'lib/assets/images/product.jpg');
                              },
                            )),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        width: 50.0,
                        height: 100.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                articles[index].data != null &&
                                        articles[index].data.length > 0
                                    ? articles[index]
                                        .data
                                        .first
                                        .title
                                        .toString()
                                    : "",
                                maxLines: 2,
                                style: TextStyles.homeTitleText(context),
                              ),
                              Text(
                                articles[index].data != null &&
                                        articles[index].data.isNotEmpty
                                    ? articles[index]
                                        .data
                                        .first
                                        .description
                                        .toString()
                                    : "",
                                maxLines: 3,
                                style: TextStyles.homeDescriptionText(context),
                              ),
                            ]),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
