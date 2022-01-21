import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  String? userUID;
  String? path;

  Photo({this.userUID, this.path});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  static Future<List<Photo>> getAll() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final List<Photo> photos = [];

    await FirebaseFirestore.instance
        .collection('photos')
        .where('userUID', isEqualTo: currentUser!.uid)
        .get()
        .then((values) async {
      return values.docs.map((doc) {
        photos.add(Photo.fromJson(doc.data()));
      });
    });

    print(photos);

    return photos;
  }

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
