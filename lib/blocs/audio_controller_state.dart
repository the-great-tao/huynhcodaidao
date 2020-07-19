import 'package:equatable/equatable.dart';

abstract class AudioControllerState extends Equatable {
  const AudioControllerState();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'State: ${this.runtimeType.toString()}';
}

class AudioControllerInitial extends AudioControllerState {}

class AudioControllerHiding extends AudioControllerState {}

class AudioControllerShowing extends AudioControllerState {}
