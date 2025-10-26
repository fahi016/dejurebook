import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_bloc.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_event.dart';

class HomeContent extends StatelessWidget {
  final int currentTabIndex;

  const HomeContent({
    super.key,
    required this.currentTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(context),
        Expanded(
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(context, 'deJure', 0),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 30)),
          _buildTab(context, 'News', 1),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 30)),
          _buildTab(context, 'Quires', 2),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = currentTabIndex == index;

    return GestureDetector(
      onTap: () {
        context.read<ConsumerBloc>().add(ChangeContentTabEvent(index));
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.getPrimaryColor(context)
                  : AppColors.getOnSurfaceColor(context),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          if (isSelected)
            Container(
              width: ResponsiveUtils.getResponsiveSpacing(context, 30),
              height: ResponsiveUtils.getResponsiveSpacing(context, 3),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryColor(context),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                      ResponsiveUtils.getResponsiveSpacing(context, 2)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Builder(
      builder: (context) {
        switch (currentTabIndex) {
          case 0:
            return _buildDeJureContent(context);
          case 1:
            return _buildNewsContent(context);
          case 2:
            return _buildQuiresContent(context);
          default:
            return _buildDeJureContent(context);
        }
      },
    );
  }

  Widget _buildDeJureContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: ResponsiveUtils.getResponsiveFontSize(context, 64),
            color: AppColors.grey,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'Welcome to deJure',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: AppColors.getOnSurfaceColor(context),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            'Your legal journey starts here',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: ResponsiveUtils.getResponsiveFontSize(context, 64),
            color: AppColors.grey,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'Legal News',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: AppColors.getOnSurfaceColor(context),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            'Stay updated with latest legal news',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiresContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer,
            size: ResponsiveUtils.getResponsiveFontSize(context, 64),
            color: AppColors.grey,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'Legal Queries',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: AppColors.getOnSurfaceColor(context),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            'Ask questions and get legal advice',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
