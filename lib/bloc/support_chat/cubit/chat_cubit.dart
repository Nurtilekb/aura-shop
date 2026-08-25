// lib/features/chat/cubit/chat_cubit.dart
import 'dart:async';

import 'package:aurashop/repositories/chat_repository.dart';
import 'package:aurashop/shared/models/chat_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;

  ChatCubit(this._repository) : super(ChatInitial());

  // Загрузить чат
  Future<void> loadChat(String userId) async {
    if (userId.isEmpty) {
      emit(const ChatError('Пользователь не авторизован'));
      return;
    }

    emit(ChatLoading());
    try {
      final chat = await _repository.getOrCreateChat(userId);
      emit(ChatLoaded(chat: chat, messages: [], isTyping: false));

      // Подписаться на сообщения
      _listenMessages(chat.id);

      // Подписаться на статус печатания
      _listenTyping(chat.id);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Загрузить существующий чат по ID
  Future<void> loadChatById(String chatId) async {
    if (chatId.isEmpty) {
      emit(const ChatError('Идентификатор чата отсутствует'));
      return;
    }

    emit(ChatLoading());
    try {
      final chat = await _repository.getChatById(chatId);
      emit(ChatLoaded(chat: chat, messages: [], isTyping: false));

      _listenMessages(chat.id);
      _listenTyping(chat.id);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Отправить сообщение
  Future<void> sendMessage({
    required String text,
    String? orderNumber,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    final state = this.state;
    if (state is! ChatLoaded) return;

    try {
      await _repository.sendMessage(
        chatId: state.chat.id,
        text: text,
        orderNumber: orderNumber,
        type: type,
        imageUrl: imageUrl,
      );

      // Останавливаем статус печатания
      _repository.sendTypingStatus(state.chat.id, false);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Отправить статус печатания
  Future<void> setTyping(bool isTyping) async {
    final state = this.state;
    if (state is! ChatLoaded) return;
    await _repository.sendTypingStatus(state.chat.id, isTyping);
  }

  // Отметить как прочитанное
  Future<void> markAsRead() async {
    final state = this.state;
    if (state is! ChatLoaded) return;
    await _repository.markMessagesAsRead(state.chat.id);
  }

  // Закрыть чат
  Future<void> closeChat() async {
    final state = this.state;
    if (state is! ChatLoaded) return;
    await _repository.closeChat(state.chat.id);
  }

  void _listenMessages(String chatId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _repository.getMessages(chatId).listen((messages) {
      final state = this.state;
      if (state is ChatLoaded) {
        emit(state.copyWith(messages: messages));

        // Если есть новые сообщения не от текущего пользователя
        final hasNewMessages = messages.any(
          (msg) => msg.senderId != _repository.currentUserId && !msg.isRead,
        );

        if (hasNewMessages) {
          markAsRead();
        }
      }
    }, onError: (error) => emit(ChatError(error.toString())));
  }

  void _listenTyping(String chatId) {
    _typingSubscription?.cancel();
    _typingSubscription = _repository.getTypingStatus(chatId).listen((
      isTyping,
    ) {
      final state = this.state;
      if (state is ChatLoaded && state.isTyping != isTyping) {
        emit(state.copyWith(isTyping: isTyping));
      }
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    return super.close();
  }
}
