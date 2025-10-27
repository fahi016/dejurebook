import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/pages/followers/bloc/followers_bloc.dart';
import 'package:dejurebook/pages/followers/bloc/followers_event.dart';
import 'package:dejurebook/pages/followers/bloc/followers_state.dart';

class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = FollowersBloc();
        bloc.add(const LoadFollowersEvent());
        return bloc;
      },
      child: const FollowersView(),
    );
  }
}

class FollowersView extends StatelessWidget {
  const FollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowersBloc, FollowersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: _buildAppBar(context),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.close,
          color: AppColors.black,
          size: 24,
        ),
      ),
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FollowersState state) {
    return Column(
      children: [
        // Tabs
        _buildTabs(context, state),

        // Content
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildUserList(state),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, FollowersState state) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<FollowersBloc>().add(const SwitchTabEvent(0));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: state.currentTabIndex == 0
                        ? AppColors.black
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Followers',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: state.currentTabIndex == 0
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<FollowersBloc>().add(const SwitchTabEvent(1));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: state.currentTabIndex == 1
                        ? AppColors.black
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Following',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: state.currentTabIndex == 1
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserList(FollowersState state) {
    final users =
        state.currentTabIndex == 0 ? state.followers : state.following;

    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No users found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserItem(users[index]);
      },
    );
  }

  Widget _buildUserItem(UserItem user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: user.profileImageUrl != null
                ? ClipOval(
                    child: Image.network(
                      user.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                      'assets/images/message_profile_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              user.username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
