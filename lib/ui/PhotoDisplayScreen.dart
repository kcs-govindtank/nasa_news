import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_news/ui/DetailScreen.dart';

import '../constants/common.dart';

class PhotoDisplayScreen extends StatefulWidget {
  const PhotoDisplayScreen({Key? key, }) : super(key: key);

  @override
  State<PhotoDisplayScreen> createState() => _PhotoDisplayScreenState();
}

class _PhotoDisplayScreenState extends State<PhotoDisplayScreen> {


  @override
  Widget build(BuildContext context) {
    final imageData = ModalRoute.of(context)?.settings.arguments as ImageDataArguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            imageData.imageTitle,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            scaleFactor: 1.4,
            scaleEnabled: true,
            panEnabled: true, // Set it to false
            boundaryMargin: const EdgeInsets.all(54),
            minScale: 1,
            maxScale: 4,
            child:
            CachedNetworkImage(
              imageUrl: imageData.imageUrl,
              width: 400,
              height: 400,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => CM.loading(),
              errorWidget: (context, url, error) => Icon(Icons.no_photography_outlined),
            )
            /*Image.network(
              imageData.imageUrl,
              width: 400,
              height: 400,
              fit: BoxFit.fill,
            ),*/
          ),
        )
    );
  }
}
