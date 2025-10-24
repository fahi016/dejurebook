import 'package:dejurebook/pages/messages/message_screen.dart';
import 'package:dejurebook/pages/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dejurebook/constants/app_colors.dart';
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
      backgroundColor: AppColors.white,
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
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MessageScreen()));
                },
                icon: Image.asset(
                  'assets/images/chat.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),

          // 🔹 Center (deJure Premium)
          Expanded(
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'deJure Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
          ),

          // 🔹 Right side (Profile)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
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
        color: AppColors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: GNav(
            backgroundColor: AppColors.white,
            color: Colors.grey.shade400,
            activeColor: AppColors.white,
            tabBackgroundColor: AppColors.black,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
