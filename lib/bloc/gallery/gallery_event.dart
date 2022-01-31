import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test_task/bloc/gallery/index.dart';
import 'package:flutter_test_task/models/photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

@immutable
abstract class GalleryEvent {
  Stream<GalleryState> applyAsync(
      {GalleryState currentState, GalleryBloc bloc});
}

class LoadingGalleryEvent extends GalleryEvent {
  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    yield LoadingGalleryState();
  }
}

class RemovePhotoGalleryEvent extends GalleryEvent {
  final Photo photo;

  RemovePhotoGalleryEvent(this.photo);

  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    yield LoadingGalleryState();
    await photo.destroy();
    bloc!.add(LoadGalleryEvent());
  }
}

class UploadingGalleryEvent extends GalleryEvent {
  final double progress;

  UploadingGalleryEvent(this.progress);

  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    yield UploadingGalleryState(progress);
  }
}

class UploadFailedGalleryEvent extends GalleryEvent {
  final String message;
  UploadFailedGalleryEvent(this.message);

  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    yield ErrorGalleryState(message);
  }
}

// class UploadedGalleryEvent extends GalleryEvent {
//   final Photo photo;
//   UploadedGalleryEvent(this.photo);

//   @override
//   Stream<GalleryState> applyAsync(
//       {GalleryState? currentState, GalleryBloc? bloc}) async* {
//     yield ShowGalleryState();
//   }
// }

class AddPhotoGalleryEvent extends GalleryEvent {
  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      String fileName = basename(pickedFile!.path);

      Reference ref = FirebaseStorage.instance.ref('uploads/$fileName');
      UploadTask task = ref.putFile(File(pickedFile.path));

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        bloc!.add(UploadingGalleryEvent(
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100));
      });

      await task;

      ref.getDownloadURL().then((value) {
        Photo.add(value);
        bloc!.add(LoadGalleryEvent());
      });
    } on FirebaseException catch (e) {
      yield ErrorGalleryState(e.message!);
      return;
    }
  }
}

class LoadGalleryEvent extends GalleryEvent {
  @override
  Stream<GalleryState> applyAsync(
      {GalleryState? currentState, GalleryBloc? bloc}) async* {
    try {
      yield LoadingGalleryState();
      final List<Photo> photos = await Photo.getAll();
      yield ShowGalleryState(photos);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadGalleryEvent', error: _, stackTrace: stackTrace);
      yield ErrorGalleryState(_.toString());
    }
  }
}
