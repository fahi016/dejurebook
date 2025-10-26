import 'package:dejurebook/pages/messages/message_screen.dart';
import 'package:dejurebook/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_bloc.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_event.dart';
import 'package:dejurebook/pages/consumer/bloc/consumer_state.dart';
import 'package:dejurebook/pages/consumer/widgets/home_content.dart';
import 'package:dejurebook/pages/consumer/widgets/awaz_content.dart';
import 'package:dejurebook/pages/consumer/widgets/reels_content.dart';

class ConsumerHomePage extends StatelessWidget {
  const ConsumerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsumerBloc()..add(const LoadHomeDataEvent()),
      child: const ConsumerHomeView(),
    );
  }
}

class ConsumerHomeView extends StatelessWidget {
  const ConsumerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: _buildAppBar(context),
          body: _buildBody(state),
          bottomNavigationBar: _buildBottomNav(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.getSurfaceColor(context),
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Left side (Notification + Message)
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/images/notification_image.png',
                  width: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  height: ResponsiveUtils.getResponsiveFontSize(context, 24),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MessageScreen()));
                },
                icon: Image.asset(
                  'assets/images/chat.png',
                  width: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  height: ResponsiveUtils.getResponsiveFontSize(context, 24),
                ),
              ),
            ],
          ),

          // 🔹 Center (deJure Premium)
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'deJure Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.successGreen,
                    fontSize:
                        ResponsiveUtils.getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.getResponsiveSpacing(context, 40),
          ),

          // 🔹 Right side (Profile)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: Container(
              width: ResponsiveUtils.getResponsiveFontSize(context, 36),
              height: ResponsiveUtils.getResponsiveFontSize(context, 36),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/profile_image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ConsumerState state) {
    switch (state.currentNavIndex) {
      case 0:
        return HomeContent(currentTabIndex: state.currentContentTabIndex);
      case 1:
        return const AwazContent();
      case 2:
        return const ReelsContent();
      default:
        return HomeContent(currentTabIndex: state.currentContentTabIndex);
    }
  }

  Widget _buildBottomNav(BuildContext context, ConsumerState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: GNav(
            backgroundColor: AppColors.getSurfaceColor(context),
            color: AppColors.grey,
            activeColor: AppColors.white,
            tabBackgroundColor: AppColors.getPrimaryColor(context),
            gap: ResponsiveUtils.getResponsiveSpacing(context, 8),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 20),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                leading: state.currentNavIndex == 0
                    ? Image.asset(
                        'assets/images/home_nav.png',
                        width: 24,
                        height: 24,
                        color: AppColors.white,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0E0E0), // Grey circle background
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/home_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey.shade600,
                        ),
                      ),
              ),
              GButton(
                icon: Icons.airplanemode_active,
                text: 'Awaz',
                leading: state.currentNavIndex == 1
                    ? Image.asset(
                        'assets/images/awaz_nav.png',
                        width: 24,
                        height: 24,
                        color: AppColors.white,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0E0E0),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/awaz_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey.shade600,
                        ),
                      ),
              ),
              GButton(
                icon: Icons.play_circle_outline,
                text: 'Reels',
                leading: state.currentNavIndex == 2
                    ? Image.asset(
                        'assets/images/reels_nav.png',
                        width: 24,
                        height: 24,
                        color: AppColors.white,
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0E0E0),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/reels_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey.shade600,
                        ),
                      ),
              ),
            ],
            selectedIndex: state.currentNavIndex,
            onTabChange: (index) {
              context.read<ConsumerBloc>().add(ChangeNavEvent(index));
            },
          ),
        ),
      ),
    );
  }
}
