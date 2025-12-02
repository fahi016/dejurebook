import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/profile/bloc/profile_bloc.dart';
import 'package:dejurebook/pages/profile/bloc/profile_event.dart';
import 'package:dejurebook/pages/profile/bloc/profile_state.dart';
import 'package:dejurebook/pages/settings/settings_screen.dart';
import 'package:dejurebook/pages/followers/followers_page.dart';
import 'package:dejurebook/pages/messages/message_screen.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:dejurebook/models/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const LoadProfileDataEvent()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await ProfileService.getCurrentUserProfile();
      debugPrint(
          'Profile loaded: ${profile?.fullName}, ${profile?.profession}');
      setState(() {
        _userProfile = profile;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _buildAppBar(context),
          body: _buildBody(context, state),
        );
      },
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
          // Close button
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),

          // Title
          Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.w600,
            ),
          ),

          // Settings button
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: Image.asset(
              'assets/images/settings_image.png',
              width: ResponsiveUtils.getResponsiveFontSize(context, 24),
              height: ResponsiveUtils.getResponsiveFontSize(context, 24),
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: ResponsiveUtils.getResponsiveFontSize(context, 24),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final profession =
        (_userProfile?.profession ?? state.profession).toLowerCase();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileHeader(context, state),

                  SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                  ),

                  _buildPrimaryActions(context, state),

                  // Only add spacing if user is NOT a lawyer (consumer with "Become a Creator" button)
                  if (profession != "lawyer")
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                    ),
                ],
              ),
            ),
          ),
          if (profession == "lawyer") _buildTabs(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text, {
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveSpacing(context, 15),
          ),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileState state) {
    final theme = Theme.of(context);
    final name = _userProfile?.fullName ?? state.name;
    final profession = _userProfile?.profession ?? state.profession;
    final joinText = _userProfile?.createdAt != null
        ? 'Joined ${_getFormattedDate(_userProfile!.createdAt!)}'
        : 'Joined ${state.joinDate}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with verification badge
        Stack(
          children: [
            // Profile Image
            Container(
              width: ResponsiveUtils.getResponsiveFontSize(context, 110),
              height: ResponsiveUtils.getResponsiveFontSize(context, 110),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile_picture_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onSurfaceVariant,
                        size:
                            ResponsiveUtils.getResponsiveFontSize(context, 40),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ✅ Custom Verified Badge (ONLY for lawyers)
            if (profession.toLowerCase() == "lawyer")
              Positioned(
                right: 0,
                top: 0,
                child: Image.asset(
                  'assets/images/verified_badge_image.png',
                  width: ResponsiveUtils.getResponsiveFontSize(context, 32),
                  height: ResponsiveUtils.getResponsiveFontSize(context, 32),
                ),
              ),
          ],
        ),

        SizedBox(
          height: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        Text(
          joinText,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ResponsiveUtils.getResponsiveSpacing(context, 4),
        ),
        // If lawyer → show special subtitle
        if (profession.toLowerCase() == "lawyer")
          Text(
            "Qualified Advocate by Bar Council of India.",
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: theme.colorScheme.onBackground.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
        else
          Text(
            profession,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: theme.colorScheme.onBackground.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildPrimaryActions(BuildContext context, ProfileState state) {
    final profession =
        (_userProfile?.profession ?? state.profession).toLowerCase();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                '${state.followersCount} Followers',
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FollowersPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: _buildActionButton(
                context,
                'Messages',
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
                borderColor: Theme.of(context).colorScheme.outline,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MessageScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Consumers only
        if (profession != "lawyer") ...[
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              context,
              'Become a Creator',
              backgroundColor: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.onSurface,
              borderColor: Theme.of(context).colorScheme.outline,
              onTap: () {
                context.read<ProfileBloc>().add(const BecomeCreatorEvent());
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            labelColor: theme.colorScheme.onBackground,
            unselectedLabelColor:
                theme.colorScheme.onBackground.withOpacity(0.6),
            indicatorColor: theme.colorScheme.onBackground,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'About'),
              Tab(text: 'Analytics'),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 260),
            child: TabBarView(
              children: [
                _buildEmptyTabMessage(
                    context, 'No posts yet', 'Your content will appear here.'),
                _buildAboutTab(context),
                _buildEmptyTabMessage(context, 'Analytics coming soon',
                    'Track your impact and engagement here.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTabMessage(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 8),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 8),
          ),
          _buildAboutItem(context, 'Secondary Education'),
          _buildAboutItem(context, 'Higher Secondary'),
          _buildAboutItem(context, 'Undergraduation'),
          _buildAboutItem(context, 'Masters'),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 24),
          ),
          Text(
            'Experience',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getResponsiveSpacing(context, 8),
          ),
          Text(
            'Add your experience to showcase your journey.',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
          color: theme.colorScheme.onBackground.withOpacity(0.9),
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
