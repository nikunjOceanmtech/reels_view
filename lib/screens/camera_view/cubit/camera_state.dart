part of 'camera_cubit.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitialState extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraLoadedState extends CameraState {
  final bool isVideoRecoding;
  final double? random;

  const CameraLoadedState({required this.isVideoRecoding, this.random});

  CameraLoadedState copyWith({
    bool? isVideoRecoding,
    double? random,
  }) {
    return CameraLoadedState(
      isVideoRecoding: isVideoRecoding ?? this.isVideoRecoding,
      random: random ?? this.random,
    );
  }

  @override
  List<Object?> get props => [isVideoRecoding, random];
}

class CameraErrorState extends CameraState {}
