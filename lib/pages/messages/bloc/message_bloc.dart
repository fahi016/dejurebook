import 'package:dejurebook/pages/messages/bloc/message_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_state.dart';
import 'package:dejurebook/models/message_model.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<LoadMessagesEvent>((event, emit) {
      final messages = List.generate(
        5,
        (index) => Message(
          username: 'Username',
          message: 'Hey there i am avas... Can we connect..',
          imagePath: 'assets/images/message_profile_image.png',
        ),
      );
      emit(MessageLoaded(messages));
    });
  }
}
