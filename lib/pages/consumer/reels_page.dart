import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_bloc.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_event.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_state.dart';
import 'package:video_player/video_player.dart';
// Removed Chewie to reduce overhead; use VideoPlayer directly
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Set<int> _initializing = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeAllControllers();
    super.dispose();
  }

  void _disposeAllControllers() {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
  }

  void _preloadVideos(List<ReelItem> reels, int currentIndex) {
    // Preload current and next 1 video (limit concurrent work)
    for (int i = currentIndex; i < currentIndex + 2 && i < reels.length; i++) {
      if (!_videoControllers.containsKey(i) && !_initializing.contains(i)) {
        _initializeVideo(i, reels[i].videoUrl);
      }
    }

    // Dispose videos that are far away (more than 2 positions)
    final keysToRemove = _videoControllers.keys
        .where((key) => (key - currentIndex).abs() > 2)
        .toList();

    for (final key in keysToRemove) {
      _videoControllers[key]?.dispose();
      _videoControllers.remove(key);
    }
  }

  Future<void> _initializeVideo(int index, String url) async {
    try {
      _initializing.add(index);
      // Cache video file before initializing player for better performance
      final file = await DefaultCacheManager().getSingleFile(url);

      final controller = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      await controller.initialize();

      if (!mounted) {
        controller.dispose();
        return;
      }

      controller.setLooping(true);
      controller.setVolume(0.0); // start muted for autoplay smoothness
      _videoControllers[index] = controller;

      if (mounted) setState(() {});

      // Auto-play if this is the current video
      if (index == _currentIndex) {
        controller.play();
      }
    } catch (e) {
      debugPrint('Error initializing video at index $index: $e');
    } finally {
      _initializing.remove(index);
    }
  }

  void _handlePageChange(int index, List<ReelItem> reels) {
    // Pause previous video
    _videoControllers[_currentIndex]?.pause();

    setState(() {
      _currentIndex = index;
    });

    // Play current video
    final currentController = _videoControllers[index];
    if (currentController != null && currentController.value.isInitialized) {
      currentController.play();
    }

    // Preload nearby videos
    _preloadVideos(reels, index);

    // Update bloc
    context.read<ConsumerBloc>().add(ChangeReelEvent(index));
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

        // Preload videos when reels are loaded
        if (_videoControllers.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadVideos(state.reels, _currentIndex);
          });
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
              return _buildReelItem(
                context,
                reel,
                index,
                isActive: isActive,
              );
            },
            onPageChanged: (index) => _handlePageChange(index, state.reels),
          ),
        );
      },
    );
  }

  Widget _buildReelItem(
    BuildContext context,
    ReelItem reel,
    int index, {
    required bool isActive,
  }) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final screenHeight = ResponsiveUtils.getScreenHeight(context);

    return Container(
      color: AppColors.black,
      child: Stack(
        children: [
          // Video player
          Positioned.fill(
            child: _buildVideoPlayer(
              index,
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
                    color: AppColors.white,
                    size: ResponsiveUtils.getResponsiveFontSize(context, 28),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.white,
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
                  label: '${reel.likes}',
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
                    AppColors.black.withOpacity(0.8),
                    AppColors.black.withOpacity(0.4),
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
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              );
                            },
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

  Widget _buildVideoPlayer(
    int index, {
    required double width,
    required double height,
    required bool play,
  }) {
    final videoController = _videoControllers[index];

    if (videoController == null || !videoController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.white,
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: VideoPlayer(videoController),
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
            size: ResponsiveUtils.getResponsiveFontSize(context, 28),
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
