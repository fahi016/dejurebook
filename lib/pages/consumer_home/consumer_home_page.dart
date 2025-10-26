import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/pages/consumer_home/bloc/consumer_home_bloc.dart';
import 'package:dejurebook/pages/consumer_home/bloc/consumer_home_event.dart';
import 'package:dejurebook/pages/consumer_home/bloc/consumer_home_state.dart';
import 'package:dejurebook/pages/consumer/widgets/home_content.dart';

class ConsumerHomePage extends StatelessWidget {
  const ConsumerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsumerHomeBloc()..add(const LoadHomeDataEvent()),
      child: const ConsumerHomeView(),
    );
  }
}

class ConsumerHomeView extends StatelessWidget {
  const ConsumerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerHomeBloc, ConsumerHomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: HomeContent(currentTabIndex: state.currentContentTabIndex),
        );
      },
    );
  }
}
