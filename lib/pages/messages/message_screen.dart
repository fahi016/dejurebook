import 'package:dejurebook/pages/messages/bloc/message_bloc.dart';
import 'package:dejurebook/pages/messages/bloc/message_event.dart';
import 'package:dejurebook/pages/messages/bloc/message_state.dart';
import 'package:dejurebook/widgets/message_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            alignment: Alignment.center,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
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
                  itemBuilder: (context, index) =>
                      MessageTile(message: state.messages[index],),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const Center(child: Text('No Groups yet')),
          const Center(child: Text('No Requests yet')),
        ],
      ),
    );
  }
}
