import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_bloc.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_event.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_state.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReelsPage extends StatelessWidget {
  final int initialIndex;

  const ReelsPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsumerBloc()..add(const LoadReelsDataEvent()),
      child: ReelsPageView(initialIndex: initialIndex),
    );
  }
}

class ReelsPageView extends StatefulWidget {
  final int initialIndex;

  const ReelsPageView({
    super.key,
    required this.initialIndex,
  });

  @override
  State<ReelsPageView> createState() => _ReelsPageViewState();
}

class _ReelsPageViewState extends State<ReelsPageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state.reels.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.black,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.black,
          body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: state.reels.length,
            itemBuilder: (context, index) {
              final reel = state.reels[index];
              final isActive = index == _currentIndex;
              return _buildReelItem(context, reel, isActive: isActive);
            },
            onPageChanged: (index) {
              context.read<ConsumerBloc>().add(ChangeReelEvent(index));
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildReelItem(BuildContext context, ReelItem reel,
      {required bool isActive}) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final screenHeight = ResponsiveUtils.getScreenHeight(context);

    return Container(
      color: AppColors.darkGrey,
      child: Stack(
        children: [
          // Video player
          Positioned.fill(
            child: _ReelVideoPlayer(
              url: reel.videoUrl,
              width: ResponsiveUtils.isMobile(context) ? screenWidth : 400,
              height: ResponsiveUtils.isMobile(context) ? screenHeight : 700,
              play: isActive,
            ),
          ),

          // Top bar (close button)
          SafeArea(
            child: Padding(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.getOnSurfaceColor(context),
                    size: ResponsiveUtils.getResponsiveFontSize(context, 28),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate back
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.getOnSurfaceColor(context),
                      size: ResponsiveUtils.getResponsiveFontSize(context, 28),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side action buttons
          Positioned(
            bottom: ResponsiveUtils.getResponsiveSpacing(context, 120),
            right: ResponsiveUtils.getResponsiveSpacing(context, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.favorite,
                  label: 'Like',
                  isActive: reel.isLiked,
                  onTap: () {
                    context.read<ConsumerBloc>().add(LikeReelEvent(reel.id));
                  },
                ),
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                _buildActionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '${reel.comments}',
                  onTap: () {
                    context.read<ConsumerBloc>().add(CommentReelEvent(reel.id));
                  },
                ),
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
                _buildActionButton(
                  context,
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    context.read<ConsumerBloc>().add(ShareReelEvent(reel.id));
                  },
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 40),
                )
              ],
            ),
          ),

          // Bottom user info and caption
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: ResponsiveUtils.getResponsivePadding(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width:
                            ResponsiveUtils.getResponsiveFontSize(context, 40),
                        height:
                            ResponsiveUtils.getResponsiveFontSize(context, 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile_picture_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: ResponsiveUtils.getResponsiveSpacing(
                              context, 12)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<ConsumerBloc>()
                                .add(FollowUserEvent(reel.username));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: ResponsiveUtils.isMobile(context)
                                    ? 200
                                    : 0),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getResponsiveSpacing(
                                  context, 12),
                              vertical: ResponsiveUtils.getResponsiveSpacing(
                                  context, 8),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              reel.isFollowing ? 'Following' : 'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                    context, 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
                  Row(
                    children: [
                      SizedBox(
                        width:
                            ResponsiveUtils.getResponsiveFontSize(context, 50),
                      ),
                      Text(
                        reel.username,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context, 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                  Text(
                    reel.caption,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 14),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.errorRed : AppColors.white,
            size: ResponsiveUtils.getResponsiveFontSize(context, 24),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final bool play;

  const _ReelVideoPlayer({
    required this.url,
    required this.width,
    required this.height,
    required this.play,
  });

  @override
  State<_ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<_ReelVideoPlayer> {
  VideoPlayerController? _vpController;
  ChewieController? _chewieController;
  bool _initError = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  Future<void> _initControllers() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await controller.initialize();
      controller.setLooping(true);
      _vpController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: widget.play,
        looping: true,
        showControls: false,
        allowFullScreen: false,
        allowMuting: true,
        aspectRatio: controller.value.aspectRatio == 0
            ? 9 / 16
            : controller.value.aspectRatio,
      );
      if (mounted) setState(() {});
      _syncPlayback();
    } catch (_) {
      _initError = true;
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant _ReelVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _disposeControllers();
      _initControllers();
    } else if (oldWidget.play != widget.play) {
      _syncPlayback();
    }
  }

  void _syncPlayback() {
    final c = _vpController;
    if (c == null) return;
    if (widget.play) {
      c.play();
    } else {
      c.pause();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _vpController?.dispose();
    _chewieController = null;
    _vpController = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_initError) {
      return Center(
        child: Icon(
          Icons.error_outline,
          color: AppColors.white,
          size: 40,
        ),
      );
    }
    if (_vpController == null || !_vpController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }
}
