import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/photo.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({Key? key, required this.photo}) : super(key: key);

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(children: [
      Image.network(photo.path),
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
                if (exit) photo.destroy();
              });
            },
            icon: const Icon(Icons.delete_forever),
          ))
    ]));
  }
}
