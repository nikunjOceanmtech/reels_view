import 'package:equatable/equatable.dart';

class ShortsEditorState extends Equatable {
  const ShortsEditorState();

  @override
  List<Object?> get props => [];
}

class ShortsEditorInitialState extends ShortsEditorState {
  @override
  List<Object?> get props => [];
}

class ShortsEditorLoadingState extends ShortsEditorState {
  @override
  List<Object?> get props => [];
}

class ShortsEditorLoadedState extends ShortsEditorState {
  final bool isFilterShow;
  final bool isLoadingVideo;
  final String filterPath;
  final double? random;

  const ShortsEditorLoadedState({
    required this.isFilterShow,
    required this.filterPath,
    required this.isLoadingVideo,
    this.random,
  });

  ShortsEditorLoadedState copyWith({
    bool? isFilterShow,
    bool? isLoadingVideo,
    String? filterPath,
    double? random,
  }) {
    return ShortsEditorLoadedState(
      isFilterShow: isFilterShow ?? this.isFilterShow,
      isLoadingVideo: isLoadingVideo ?? this.isLoadingVideo,
      filterPath: filterPath ?? this.filterPath,
      random: random ?? this.random,
    );
  }

  @override
  List<Object?> get props => [isFilterShow, filterPath, random, isLoadingVideo];
}

class ShortsEditorErrorState extends ShortsEditorState {
  @override
  List<Object?> get props => [];
}
