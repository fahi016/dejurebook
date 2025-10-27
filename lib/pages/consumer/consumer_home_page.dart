import 'package:dejurebook/pages/messages/message_screen.dart';
import 'package:dejurebook/pages/profile/profile_page.dart';
import 'package:dejurebook/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    return WillPopScope(
      onWillPop: () async {
        // Close the app when back button is pressed
        return true;
      },
      child: BlocBuilder<ConsumerBloc, ConsumerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: _buildAppBar(context),
            body: _buildBody(state),
            bottomNavigationBar: _buildBottomNav(context, state),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                icon: CustomImageWidget(
                  imagePath: 'assets/images/notification_image.png',
                  width: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  height: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  errorWidget: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MessageScreen()));
                },
                icon: CustomImageWidget(
                  imagePath: 'assets/images/chat.png',
                  width: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  height: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  errorWidget: Icon(
                    Icons.chat_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  ),
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'deJure Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF5C7600),
                    fontSize:
                        ResponsiveUtils.getResponsiveFontSize(context, 14),
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
              child: CustomImageWidget(
                imagePath: 'assets/images/profile_image.png',
                fit: BoxFit.cover,
                errorWidget: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: ResponsiveUtils.getResponsiveFontSize(context, 20),
                ),
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
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.surface,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            activeColor: Colors.white,
            tabBackgroundColor: const Color(0xFF252525),
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
                    ? CustomImageWidget(
                        imagePath: 'assets/images/home_nav.png',
                        width: 30,
                        height: 30,
                        errorWidget: Icon(
                          Icons.home,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: CustomImageWidget(
                          imagePath: 'assets/images/home_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey,
                          errorWidget: Icon(
                            Icons.home_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
              ),
              GButton(
                icon: Icons.airplanemode_active,
                text: 'Awaz',
                leading: state.currentNavIndex == 1
                    ? CustomImageWidget(
                        imagePath: 'assets/images/awaz_nav.png',
                        width: 30,
                        height: 30,
                        color: Colors.grey,
                        errorWidget: Icon(
                          Icons.airplanemode_active,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: CustomImageWidget(
                          imagePath: 'assets/images/awaz_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey,
                          errorWidget: Icon(
                            Icons.airplanemode_active_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
              ),
              GButton(
                icon: Icons.play_circle_outline,
                text: 'Reels',
                leading: state.currentNavIndex == 2
                    ? CustomImageWidget(
                        imagePath: 'assets/images/reels_nav.png',
                        width: 30,
                        height: 30,
                        color: Colors.grey,
                        errorWidget: Icon(
                          Icons.play_circle,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: CustomImageWidget(
                          imagePath: 'assets/images/reels_nav.png',
                          width: 24,
                          height: 24,
                          color: Colors.grey,
                          errorWidget: Icon(
                            Icons.play_circle_outline,
                            color: Colors.grey,
                            size: 24,
                          ),
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
