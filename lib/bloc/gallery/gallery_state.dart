import 'package:equatable/equatable.dart';
import 'package:flutter_test_task/models/photo.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

class LoadingGalleryState extends GalleryState {
  @override
  String toString() => 'LoadingGalleryState';
}

class UploadingGalleryState extends GalleryState {
  final double progress;
  const UploadingGalleryState(this.progress);

  @override
  String toString() => 'UploadingGalleryState';
}

class ShowGalleryState extends GalleryState {
  const ShowGalleryState(this.photos);

  final List<Photo> photos;

  @override
  String toString() => 'ShowGalleryState ${photos.length}';

  @override
  List<Object> get props => [photos];
}

class ErrorGalleryState extends GalleryState {
  const ErrorGalleryState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorGalleryState';

  @override
  List<Object> get props => [errorMessage];
}
