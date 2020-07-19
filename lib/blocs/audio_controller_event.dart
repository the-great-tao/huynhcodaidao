import 'package:equatable/equatable.dart';

abstract class AudioControllerEvent extends Equatable {
  const AudioControllerEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Event: ${this.runtimeType.toString()}';
}

class AudioControllerHide extends AudioControllerEvent {}

class AudioControllerShow extends AudioControllerEvent {}
