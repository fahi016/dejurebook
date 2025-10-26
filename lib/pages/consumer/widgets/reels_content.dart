import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_bloc.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_state.dart';
import 'package:dejurebook/pages/consumer/reels_page.dart';

class ReelsContent extends StatelessWidget {
  const ReelsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.reels.isEmpty) {
          return Center(
            child: Text(
              'No reels available',
              style: TextStyle(
                color: AppColors.getOnSurfaceColor(context),
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              ),
            ),
          );
        }

        return _buildReelsGrid(context, state.reels);
      },
    );
  }

  Widget _buildReelsGrid(BuildContext context, List<ReelItem> reels) {
    return Scaffold(
      backgroundColor: AppColors.getSurfaceColor(context),
      body: Column(
        children: [
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 40),
          ),
          Text(
            'Your Scroll Zone!!',
            style: TextStyle(
              color: AppColors.getOnSurfaceColor(context),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reels.length,
              controller: PageController(
                viewportFraction: ResponsiveUtils.isMobile(context) ? 0.8 : 0.6,
              ),
              itemBuilder: (context, index) {
                final reel = reels[index];
                return _buildReelCard(context, reel);
              },
            ),
          ),
          Padding(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: Text(
              'Random Scroll',
              style: TextStyle(
                color: AppColors.getOnSurfaceColor(context),
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 30),
          )
        ],
      ),
    );
  }

  Widget _buildReelCard(BuildContext context, ReelItem reel) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ReelsPage(initialIndex: 0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 10),
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 20),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Legal illustration background
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/reel_image.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Play button overlay
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black.withOpacity(0.8),
                ),
                padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 20)),
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.white,
                  size: ResponsiveUtils.getResponsiveFontSize(context, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
