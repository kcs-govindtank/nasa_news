import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:nasa_news/FilterItem.dart';
import 'package:nasa_news/TextStyles.dart';
import 'package:nasa_news/model/Article.dart';

import 'HttpService.dart';
import 'PhotoDisplayScreen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  var filterItems = [
    const FilterItem(
        'Thumb',
        Icon(
          Icons.view_comfortable_sharp,
          color: Colors.green,
        )),
    const FilterItem(
        'Small',
        Icon(
          Icons.view_column,
          color: Colors.green,
        )),
    const FilterItem(
        'Medium',
        Icon(
          Icons.view_agenda_sharp,
          color: Colors.green,
        )),
    const FilterItem(
        'Large',
        Icon(
          Icons.view_day,
          color: Colors.green,
        )),
  ];

  var dropdownvalue =  const FilterItem(
      'Thumb',
      Icon(
        Icons.view_comfortable_sharp,
        color: Colors.green,
      ));
  int itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.data.first.title,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: 180.0,
                  child: Image.network(
                    data.links != null && data.links.isNotEmpty
                        ? data.links.first.href.toString()
                        : "",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      print("Exception >> ${exception.toString()}");
                      return Image.asset('lib/assets/images/product.jpg');
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Date : ${Jiffy(data.data.first.dateCreated).yMMMMd}",
                      style: TextStyles.homeTitleText(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        data.data.first.description,
                        style: TextStyles.descriptionText(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Keywords : ",
                        style: TextStyles.homeTitleText(context),
                      ),
                    ),
                    chipList(data.data.first.keywords),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Image Gallery  : ",
                              style: TextStyles.homeTitleText(context)),
                          DropdownButton(
                            iconEnabledColor: Colors.green,
                            elevation: 12,
                            focusColor: Colors.black,
                            hint: Row(
                              children: [
                                dropdownvalue.icon,
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  dropdownvalue.name,
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            items: filterItems.map<DropdownMenuItem<FilterItem>>((FilterItem item) {
                              return DropdownMenuItem<FilterItem>(
                                value: item,
                                child: Row(
                                  children: [
                                    item.icon,
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item.name,
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownvalue = value as FilterItem;
                                switch (dropdownvalue.name.toLowerCase()) {
                                  case "thumb":
                                    itemCount = 4;
                                    break;
                                  case "small":
                                    itemCount = 3;
                                    break;
                                  case "medium":
                                    itemCount = 2;
                                    break;
                                  case "large":
                                    itemCount = 1;
                                    break;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _loadImages(context, data.href,
                            dropdownvalue.name.toLowerCase(), itemCount, data.data.first.title)),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  FutureBuilder<List<String>> _loadImages(
      BuildContext context, String url, String filter, int itemCount, String imageTitle) {
    final HttpService httpService = HttpService();
    return FutureBuilder<List<String>>(
      future: httpService.getImageGallery(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<String> galleryData = snapshot.requireData;
          List<String> images = galleryData
              .where((i) => i.endsWith(".jpg") && i.contains(filter))
              .toList();
          return
            // GestureDetector(
            // child:
              Card(
              borderOnForeground: false,
              elevation: 0,
              child: Container(
                // child: *Image list as child*, but don't know about the list datatype hence not created it!
                alignment: Alignment.center,
                child: GridView.builder(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: itemCount),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoDisplayScreen(),
                            settings: RouteSettings(arguments: ImageDataArguments(imageTitle,images[index]))),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.network(
                            fit: BoxFit.cover,
                            images[index],
                          ),
                        ),
                      );
                    }),
              ),
            );
          //   onTap: () {},
          // );
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget _buildChip(String label, Color color) {
  return Chip(
    visualDensity: VisualDensity.comfortable,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: color,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}

chipList(List<String> strings) {
  return Container(
    child: getTextWidgets(strings),
  );
}

Widget getTextWidgets(List<String> strings) {
  List<Widget> list = <Widget>[];
  for (var i = 0; i < strings.length; i++) {
    list.add(_buildChip(strings[i], Colors.green));
  }
  return Wrap(
    spacing: 4.0,
    runSpacing: 2.0,
    children: list,
  );
}

class ImageDataArguments {
  final String imageTitle;
  final String imageUrl;

  ImageDataArguments(this.imageTitle, this.imageUrl);
}
