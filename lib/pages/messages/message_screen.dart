import 'package:dejurebook/pages/messages/bloc/message_bloc.dart';
import 'package:dejurebook/pages/messages/bloc/message_event.dart';
import 'package:dejurebook/pages/messages/bloc/message_state.dart';
import 'package:dejurebook/widgets/message_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/app_colors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MessageBloc>().add(LoadMessagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.getSurfaceColor(context),
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.getOnSurfaceColor(context),
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.blackShade60,
            size: 26,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderColor, width: 0.8),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.grey,
              labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              unselectedLabelStyle:
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: AppColors.black),
                insets: EdgeInsets.symmetric(horizontal: 36.0),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Chats'),
                Tab(text: 'Groups'),
                Tab(text: 'Requests'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoaded) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) => MessageTile(
                    message: state.messages[index],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blackShade60,
                ),
              );
            },
          ),
          Center(
            child: Text(
              'No Groups yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
            ),
          ),
          Center(
            child: Text(
              'No Requests yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
