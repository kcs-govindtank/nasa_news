import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nasa_news/model/Article.dart';
import 'package:nasa_news/ui/DetailScreen.dart';

import '../constants/TextStyles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We will fetch data from this Rest api
  final String _baseUrl = "http://images-api.nasa.gov/search?q=moon&page=1";
  String nextPageURL = "";

  // There is next page or not
  bool _hasNextPage = true;
  bool _atTheEndOfPage = false;

  bool _isError = false;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  Collection? collection;

  // This holds the posts fetched from the server
  List<Item> _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await get(Uri.parse(_baseUrl));
      setState(() {
        collection = Article.fromJson(jsonDecode(res.body)).collection;
        setNextPageURL(collection?.links ?? []);
        _posts = collection?.items ?? [];
      });
    } catch (err) {
      setState(() {
        _isError = true;
      });
      if (kDebugMode) {
        print('Something went wrong ${err.toString()}');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      try {
        final res = await get(Uri.parse(nextPageURL));
        collection = Article.fromJson(jsonDecode(res.body)).collection;
        List<Item> fetchedPosts = collection?.items ?? [];
        setNextPageURL(collection?.links ?? []);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _isError = false;
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        setState(() {
          _isError = true;
        });
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: _isFirstLoadRunning
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : Column(children: [
                  Expanded(
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: _posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(index==_posts.length-1) {
                          _atTheEndOfPage=true;
                        } else {
                          _atTheEndOfPage=false;
                        }
                        return Card(
                          elevation: 4,
                          child: ListBody(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) => const DetailScreen(),
                                        settings:
                                        RouteSettings(
                                            arguments: _posts[index])),
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
                                              _posts[index].links != null &&
                                                  _posts[index].links.isNotEmpty
                                                  ? _posts[index]
                                                  .links
                                                  .first
                                                  .href
                                                  .toString()
                                                  : "",
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              errorBuilder: (
                                                  BuildContext context,
                                                  Object exception,
                                                  StackTrace? stackTrace) {
                                                print(
                                                    "Exception >> ${exception
                                                        .toString()}");
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                _posts[index].data != null &&
                                                    _posts[index].data.length >
                                                        0
                                                    ? _posts[index]
                                                    .data
                                                    .first
                                                    .title
                                                    .toString()
                                                    : "",
                                                maxLines: 2,
                                                style:
                                                TextStyles.homeTitleText(
                                                    context),
                                              ),
                                              Text(
                                                _posts[index].data != null &&
                                                    _posts[index].data
                                                        .isNotEmpty
                                                    ? _posts[index]
                                                    .data
                                                    .first
                                                    .description
                                                    .toString()
                                                    : "",
                                                maxLines: 3,
                                                style: TextStyles
                                                    .homeDescriptionText(
                                                    context),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                              // when the _loadMore function is running
                              if (_isLoadMoreRunning == true && _atTheEndOfPage)
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  ),

                              // When nothing else to load
                              if (_hasNextPage == false && _atTheEndOfPage)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  color: Colors.white,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('End of Page'),
                                  ),
                                ),
                              // When there is an error
                              if (_isError == true && _atTheEndOfPage)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Something went wrong, Please ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            // _isLoadMoreRunning = true;
                                            _isError = false;
                                            _loadMore();
                                          });
                                        },
                                        child: const Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: 'Retry '),
                                              WidgetSpan(
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 16,
                                                    color: Colors.green,
                                                  )),
                                            ],
                                          ),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                  ),

                ]),

      ),
    );
  }

  void setNextPageURL(List<CollectionLink> list) {
    if (list.isNotEmpty) {
      if (list.length == 2) {
        nextPageURL = list[1].href;
      } else {
        nextPageURL = list.first.href;
      }
    }
  }
}
