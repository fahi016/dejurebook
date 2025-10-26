import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/pages/consumer_awaz/bloc/consumer_awaz_bloc.dart';
import 'package:dejurebook/pages/consumer_awaz/bloc/consumer_awaz_event.dart';
import 'package:dejurebook/pages/consumer_awaz/bloc/consumer_awaz_state.dart';

class ConsumerAwazPage extends StatelessWidget {
  const ConsumerAwazPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsumerAwazBloc()..add(const LoadAwazDataEvent()),
      child: const ConsumerAwazView(),
    );
  }
}

class ConsumerAwazView extends StatelessWidget {
  const ConsumerAwazView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerAwazBloc, ConsumerAwazState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: const Center(
            child: Text('Awaz Content'),
          ),
        );
      },
    );
  }
}
