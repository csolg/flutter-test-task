import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter_test_task/bloc/gallery/index.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {

  GalleryBloc(GalleryState initialState) : super(initialState){
   on<GalleryEvent>((event, emit) {
      return emit.forEach<GalleryState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'GalleryBloc', error: error, stackTrace: stackTrace);
          return ErrorGalleryState(error.toString());
        },
      );
    });
  }
}
