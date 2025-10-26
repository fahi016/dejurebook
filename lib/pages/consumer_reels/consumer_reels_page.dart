import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/pages/consumer_reels/bloc/consumer_reels_bloc.dart';
import 'package:dejurebook/pages/consumer_reels/bloc/consumer_reels_event.dart';
import 'package:dejurebook/pages/consumer_reels/bloc/consumer_reels_state.dart';

class ConsumerReelsPage extends StatelessWidget {
  const ConsumerReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsumerReelsBloc()..add(const LoadReelsDataEvent()),
      child: const ConsumerReelsView(),
    );
  }
}

class ConsumerReelsView extends StatelessWidget {
  const ConsumerReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerReelsBloc, ConsumerReelsState>(
      builder: (context, state) {
        if (state.reels.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: state.reels.length,
          itemBuilder: (context, index) {
            final reel = state.reels[index];
            return _buildReelItem(context, reel);
          },
          onPageChanged: (index) {
            context.read<ConsumerReelsBloc>().add(ChangeReelEvent(index));
          },
        );
      },
    );
  }

  Widget _buildReelItem(BuildContext context, ReelItem reel) {
    return Container(
      color: Colors.grey.shade900,
      child: Stack(
        children: [
          // Video/Image placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video thumbnail placeholder (illustration)
                      Image.asset(
                        'assets/images/law_image.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // Play button overlay
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.brown.shade800.withOpacity(0.8),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top bar (close button)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.white,
                    size: 28,
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate back
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side action buttons
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.favorite,
                  label: 'Like',
                  onTap: () {
                    context
                        .read<ConsumerReelsBloc>()
                        .add(LikeReelEvent(reel.id));
                  },
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '${reel.comments}',
                  onTap: () {
                    context
                        .read<ConsumerReelsBloc>()
                        .add(CommentReelEvent(reel.id));
                  },
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  context,
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    context
                        .read<ConsumerReelsBloc>()
                        .add(ShareReelEvent(reel.id));
                  },
                ),
              ],
            ),
          ),

          // Bottom user info and caption
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile_picture_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<ConsumerReelsBloc>()
                                .add(FollowUserEvent(reel.username));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Follow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reel.username,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reel.caption,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
