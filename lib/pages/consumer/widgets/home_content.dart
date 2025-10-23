import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(context, 'deJure', 0),
          const SizedBox(width: 30),
          _buildTab(context, 'News', 1),
          const SizedBox(width: 30),
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
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.black
                  : const Color.fromARGB(255, 26, 26, 26),
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              width: 30,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (currentTabIndex) {
      case 0:
        return _buildDeJureContent();
      case 1:
        return _buildNewsContent();
      case 2:
        return _buildQuiresContent();
      default:
        return _buildDeJureContent();
    }
  }

  Widget _buildDeJureContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Welcome to deJure',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your legal journey starts here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Legal News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Stay updated with latest legal news',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiresContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Legal Queries',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ask questions and get legal advice',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
