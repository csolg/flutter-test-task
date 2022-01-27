import 'package:flutter/material.dart';
import 'package:flutter_test_task/models/photo.dart';

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({Key? key, required this.photo}) : super(key: key);

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Text(photo.path!);
  }
}
