// lib/features/chat/cubit/chat_state.dart
part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final Chat chat;
  final List<ChatMessage> messages;
  final bool isTyping;

  const ChatLoaded({
    required this.chat,
    required this.messages,
    this.isTyping = false,
  });

  ChatLoaded copyWith({
    Chat? chat,
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatLoaded(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [chat, messages, isTyping];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
