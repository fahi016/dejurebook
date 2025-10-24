import 'package:equatable/equatable.dart';
import 'package:dejurebook/models/message_model.dart';

abstract class MessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  MessageLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}
