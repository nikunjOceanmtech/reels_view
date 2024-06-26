import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reels_view/di/get_it.dart';
import 'package:reels_view/screens/shorts_editor/cubit/shorts_editor_cubit.dart';
import 'package:reels_view/screens/shorts_editor/cubit/shorts_editor_state.dart';
import 'package:reels_view/screens/shorts_editor/view/filter_sector.dart';
import 'package:reels_view/sticker/stories_editor.dart';
import 'package:video_player/video_player.dart';

class ShortsEditorScreen extends StatefulWidget {
  final String videoPath;
  const ShortsEditorScreen({super.key, required this.videoPath});

  @override
  State<ShortsEditorScreen> createState() => _ShortsEditorScreenState();
}

class _ShortsEditorScreenState extends State<ShortsEditorScreen> {
  late ShortsEditorCubit shortsEditorCubit;

  @override
  void initState() {
    shortsEditorCubit = getItInstance<ShortsEditorCubit>();
    shortsEditorCubit.loadVideo(filePath: widget.videoPath);
    super.initState();
  }

  @override
  void dispose() {
    shortsEditorCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShortsEditorCubit, ShortsEditorState>(
        bloc: shortsEditorCubit,
        builder: (context, state) {
          if (state is ShortsEditorLoadedState) {
            return Stack(
              fit: StackFit.expand,
              children: [
                StoriesEditor(
                  isShowFilterIcon: state.isFilterShow,
                  onDownloadTap: (imagePath) {},
                  onEffectTap: () => shortsEditorCubit.showFilterView(state: state, isFilterShow: true),
                  onFilterCancelTap: () => shortsEditorCubit.showFilterView(state: state, isFilterShow: false),
                  onFilterDoneTap: () async {
                    print("=========");
                    shortsEditorCubit.loadFilter(state: state);
                  },
                  onMusicTap: () {},
                  onVidepPlayOrPause: () {},
                  onNextButtonTap: (imagePath) {},
                  playPauseView: const SizedBox.shrink(),
                  videoView: shortsEditorCubit.videoPlayerController != null
                      ? Stack(
                          children: [
                            VideoPlayer(shortsEditorCubit.videoPlayerController!),
                            filterView(state: state),
                          ],
                        )
                      : const SizedBox.shrink(),
                  middleBottomWidget: Container(
                    height: 50,
                  ),
                ),
                Positioned(bottom: 90.h, child: filterList(state: state)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget filterView({required ShortsEditorLoadedState state}) {
    return Visibility(
      visible: state.isFilterShow,
      child: state.filterPath.isEmpty
          ? const SizedBox.shrink()
          : ClipRRect(
              child: Image.asset(
                state.filterPath,
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget filterList({required ShortsEditorLoadedState state}) {
    return Visibility(
      visible: state.isFilterShow,
      child: Container(
        height: 120.h,
        width: ScreenUtil().screenWidth,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterSelector(
                  padding: EdgeInsets.zero,
                  filters: List.generate(
                    FilterList().filters.length,
                    (index) => FilterList().filters[index].path,
                  ),
                  onFilterChanged: (selectedPath) => shortsEditorCubit.onFilterChanged(
                    state: state,
                    selectedPath: selectedPath,
                  ),
                ),
              ),
              Positioned(
                top: 5.h,
                bottom: 5.h,
                right: 5.w,
                left: 5.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
