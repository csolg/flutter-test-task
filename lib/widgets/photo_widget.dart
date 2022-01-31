import 'package:flutter/material.dart';
import 'package:flutter_test_task/bloc/gallery/gallery_bloc.dart';
import 'package:flutter_test_task/bloc/gallery/index.dart';
import 'package:flutter_test_task/models/photo.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({Key? key, required this.photo, required this.bloc})
      : super(key: key);

  final Photo photo;
  final GalleryBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(children: [
      Image.network(
        photo.path,
        errorBuilder: (context, error, stackTrace) => const Text('URL failed'),
      ),
      Positioned(
          top: 0,
          right: 10,
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: const Text('Remove Photo'),
                        content:
                            const Text('Are you sure to remove the photo?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('OK'))
                        ]);
                  }).then((exit) {
                if (exit) bloc.add(RemovePhotoGalleryEvent(photo));
              });
            },
            icon: const Icon(Icons.delete_forever),
          ))
    ]));
  }
}
