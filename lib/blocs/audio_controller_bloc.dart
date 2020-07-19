import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:bloc/bloc.dart';

import 'package:huynhcodaidao/blocs/audio_controller_event.dart';
import 'package:huynhcodaidao/blocs/audio_controller_state.dart';

final GetIt getIt = GetIt.instance;

class AudioControllerBloc
    extends Bloc<AudioControllerEvent, AudioControllerState> {
  AudioControllerBloc() : super(AudioControllerInitial());

  @override
  Stream<AudioControllerState> mapEventToState(
    AudioControllerEvent event,
  ) async* {
    if (event is AudioControllerShow) {
      yield AudioControllerShowing();
    }

    if (event is AudioControllerHide) {
      yield AudioControllerHiding();
    }
  }
}
