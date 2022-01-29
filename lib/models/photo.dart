import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  static const String collectionName = 'photos';

  String id;
  String userUID;
  String path;

  Photo({required this.id, required this.userUID, required this.path});

  static Future<Photo> add(path) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final doc =
        await collection().add({'userUID': currentUser?.uid, 'path': path});

    return Photo.get(doc.id);
  }

  static Future<Photo> get(String id) async {
    final snapshot = await collection().doc(id).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    print(data);

    return Photo.fromJson(data);
  }

  static Future<List<Photo>> getAll() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final querySnapshot =
        await collection().where('userUID', isEqualTo: currentUser!.uid).get();

    return querySnapshot.docs
        .map((doc) => Photo.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future destroy() async {
    FirebaseStorage.instance.refFromURL(path).delete().then((_) async {
      await collection().doc(id).delete();
    });
  }

  static DocumentReference ref(String document) {
    return collection().doc(document).withConverter<Photo>(
        fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
        toFirestore: (model, _) => model.toJson());
  }

  static CollectionReference collection() {
    return FirebaseFirestore.instance.collection(collectionName);
  }

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
