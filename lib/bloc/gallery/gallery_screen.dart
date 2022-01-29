import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task/bloc/gallery/index.dart';
import 'package:flutter_test_task/models/photo.dart';
import 'package:flutter_test_task/widgets/photo_widget.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({
    required GalleryBloc galleryBloc,
    Key? key,
  })  : _galleryBloc = galleryBloc,
        super(key: key);

  final GalleryBloc _galleryBloc;

  @override
  GalleryScreenState createState() {
    return GalleryScreenState();
  }
}

class GalleryScreenState extends State<GalleryScreen> {
  GalleryScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
        bloc: widget._galleryBloc,
        builder: (
          BuildContext context,
          GalleryState currentState,
        ) {
          if (currentState is ShowGalleryState) {
            return GridView.count(
                crossAxisCount: 2,
                children: currentState.photos
                    .where((photo) => photo.path != null)
                    .map((photo) => PhotoWidget(photo: photo))
                    .toList());
          }
          if (currentState is UploadingGalleryState) {
            return Center(
              child: LinearProgressIndicator(value: currentState.progress),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._galleryBloc.add(LoadGalleryEvent());
  }
}
