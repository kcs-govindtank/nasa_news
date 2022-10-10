import 'package:flutter/material.dart';
import 'package:nasa_news/ui/DetailScreen.dart';

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
            boundaryMargin: const EdgeInsets.all(24),
            minScale: 1,
            maxScale: 4,
            child: Image.network(
              imageData.imageUrl,
              width: 400,
              height: 400,
              fit: BoxFit.fill,
            ),
          ),
        )
    );
  }
}
