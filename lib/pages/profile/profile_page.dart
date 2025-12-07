import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/profile/bloc/profile_bloc.dart';
import 'package:dejurebook/pages/profile/bloc/profile_event.dart';
import 'package:dejurebook/pages/profile/bloc/profile_state.dart';
import 'package:dejurebook/pages/settings/settings_screen.dart';
import 'package:dejurebook/pages/followers/followers_page.dart';
import 'package:dejurebook/pages/messages/message_screen.dart';

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
    // Show loading indicator while fetching profile
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    // Show error if any
    if (state.error != null) {
      return Center(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading profile',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
              Text(
                state.error!,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final profession = (state.userProfile?.profession ?? state.profession ?? '')
        .toLowerCase();

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
    final name = state.userProfile?.fullName ?? state.name ?? '';
    final profession = state.userProfile?.profession ?? state.profession ?? '';
    final joinText = state.userProfile?.createdAt != null
        ? 'Joined ${_getFormattedDate(state.userProfile!.createdAt!)}'
        : state.joinDate != null
            ? 'Joined ${state.joinDate}'
            : '';

    if (profession.toLowerCase() == "lawyer") {
      final lawyerProfile = state.lawyerProfile;
      final isVerified = lawyerProfile?.isVerified ?? false;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with verification badge (only if verified)
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
                          size: ResponsiveUtils.getResponsiveFontSize(
                              context, 40),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Show verified badge only if verified
              if (isVerified)
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
          // Show verification text if verified, otherwise show profession
          Text(
            isVerified
                ? "Qualified Advocate by Bar Council of India."
                : profession,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: theme.colorScheme.onBackground.withOpacity(0.8),
              fontWeight: isVerified ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              Column(
                children: [
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
                          size: ResponsiveUtils.getResponsiveFontSize(
                              context, 40),
                        ),
                      );
                    },
                  ),
                ),
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
                ],
              ),
           

          SizedBox(
            width: ResponsiveUtils.getResponsiveSpacing(context, 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [      
              Text(
                name,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              
              Text(
                profession,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: theme.colorScheme.onBackground.withOpacity(0.9),
                ),
              ),      
            
            ],
          )
        ],
      );
    }
  }

  Widget _buildPrimaryActions(BuildContext context, ProfileState state) {
    final profession = (state.userProfile?.profession ?? state.profession ?? '')
        .toLowerCase();

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
            labelStyle:TextStyle(fontSize: 14,),
            tabs: const [
              Tab(text: 'Posts',),
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
    final state = context.watch<ProfileBloc>().state;
    final lawyerProfile = state.lawyerProfile;

    return SingleChildScrollView(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Education Section
          if (lawyerProfile?.education != null && lawyerProfile!.education.isNotEmpty) ...[
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
            Text(
              lawyerProfile.education,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: theme.colorScheme.onBackground.withOpacity(0.9),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 24),
            ),
          ],

          // Experience Section
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
          if (lawyerProfile?.experienceYears != null && lawyerProfile!.experienceYears > 0)
            Text(
              '${lawyerProfile.experienceYears} ${lawyerProfile.experienceYears == 1 ? 'year' : 'years'} of experience',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: theme.colorScheme.onBackground.withOpacity(0.9),
              ),
            )
          else
            Text(
              'No experience information available.',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),

          // Practice Areas Section
          if (lawyerProfile?.practiceAreas != null && lawyerProfile!.practiceAreas.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 24),
            ),
            Text(
              'Practice Areas',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 8),
            ),
            Wrap(
              spacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
              runSpacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
              children: lawyerProfile.practiceAreas.map((area) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                  ),
                  child: Text(
                    area.label,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Languages Section
          if (lawyerProfile?.languages != null && lawyerProfile!.languages.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 24),
            ),
            Text(
              'Languages',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 8),
            ),
            Wrap(
              spacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
              runSpacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
              children: lawyerProfile.languages.map((language) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                  ),
                  child: Text(
                    language,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // LinkedIn Section
          if (lawyerProfile?.linkedinUrl != null && lawyerProfile!.linkedinUrl.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 24),
            ),
            Text(
              'LinkedIn',
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
              lawyerProfile.linkedinUrl,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ],
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
