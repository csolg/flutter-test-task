import 'package:flutter/material.dart';
import 'package:flutter_test_task/bloc/gallery/index.dart';

class GalleryPage extends StatefulWidget {
  static const String routeName = '/gallery';

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _galleryBloc = GalleryBloc(LoadingGalleryState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GalleryScreen(galleryBloc: _galleryBloc),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _galleryBloc.add(AddPhotoGalleryEvent());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
