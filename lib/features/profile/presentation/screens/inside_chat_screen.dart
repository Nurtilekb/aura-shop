import 'dart:async';

import 'package:aurashop/bloc/messages/messages_bloc.dart';
import 'package:aurashop/bloc/messages/messages_event.dart';
import 'package:aurashop/bloc/messages/messages_state.dart';
import 'package:aurashop/repositories/chat_repository.dart';
import 'package:aurashop/repositories/message_repository.dart';
import 'package:aurashop/shared/widgets/chat_message_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChatsScreen extends StatefulWidget {
  final String numName;
  final bool isOnline;
  final String imageAvatar;
  final String userId;

  const ChatsScreen({
    super.key,
    required this.numName,
    required this.isOnline,
    required this.imageAvatar,
    required this.userId,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final Set<String> selectedMessageIds = {};
  int _lastMessageCount = 0;
  bool _hasMarkedAsRead = false;
  bool _isMarkingAsRead = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _lastDocs = [];
  late final MessagesBloc _messagesBloc;
  late final MessageRepository _messageRepository;
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  bool get _isSelectionMode => selectedMessageIds.isNotEmpty;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    final currentUserId = _currentUserId;
    if (currentUserId != null) {
      _messagesBloc.add(
        UnsubscribeMessages(chatId: _chatDocId(widget.userId, currentUserId)),
      );
    }
    _messagesBloc.close();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      final currentUserId = _currentUserId;
      if (currentUserId != null) {
        _messagesBloc.add(
          UnsubscribeMessages(
            chatId: _chatDocId(oldWidget.userId, currentUserId),
          ),
        );
        _messagesBloc.add(
          SubscribeMessages(chatId: _chatDocId(widget.userId, currentUserId)),
        );
        _markChatAsRead();
      }
      _resetChatState();
    }
  }

  @override
  void initState() {
    super.initState();
    _messageRepository = MessageRepository();
    _messagesBloc = MessagesBloc(repository: _messageRepository);
    final currentUserId = _currentUserId;
    if (currentUserId != null) {
      _messagesBloc.add(
        SubscribeMessages(chatId: _chatDocId(widget.userId, currentUserId)),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        _markChatAsRead();
      });
    }
  }

  Future<void> _markChatAsRead() async {
    if (_hasMarkedAsRead || _isMarkingAsRead) return;

    final currentUserId = _currentUserId;
    if (currentUserId == null) return;

    _isMarkingAsRead = true;
    try {
      _messagesBloc.add(
        MarkChatRead(
          chatId: _chatDocId(widget.userId, currentUserId),
          currentUserId: currentUserId,
        ),
      );
      _hasMarkedAsRead = true;
    } finally {
      _isMarkingAsRead = false;
    }
  }

  void _resetChatState() {
    _lastMessageCount = 0;
    selectedMessageIds.clear();
    _lastDocs = [];
    _hasMarkedAsRead = false;
  }

  String _chatDocId(String userId1, String userId2) {
    return ChatRepository.chatIdForParticipants(userId1, userId2);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent <= 0) return;

        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      selectedMessageIds.contains(id)
          ? selectedMessageIds.remove(id)
          : selectedMessageIds.add(id);
    });
  }

  void _clearSelection() {
    setState(() {
      selectedMessageIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _currentUserId;

    return BlocProvider.value(
      value: _messagesBloc,
      child: BlocBuilder<MessagesBloc, MessagesState>(
        builder: (context, state) {
          if (state is MessagesLoadInProgress) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is MessageError) {
            return Scaffold(
              body: Center(
                child: Text('Ошибка загрузки сообщений: ${state.message}'),
              ),
            );
          }
          if (state is MessagesLoadSuccess) {
            _lastDocs = state.docs;
          }
          final docs = _lastDocs;
          if (docs.isNotEmpty && currentUserId != null && !_hasMarkedAsRead) {
            unawaited(_markChatAsRead());
          }
          if (docs.isNotEmpty && currentUserId != null) {
            _lastMessageCount = docs.length;
            if (_shouldScrollToBottom(docs.length)) {
              _scrollToBottom();
            }
          }
          return Scaffold(
            appBar: _isSelectionMode
                ? _buildSelectionAppBar()
                : _buildChatAppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  _buildMessageArea(currentUserId, docs),
                  _buildComposer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageArea(
    String? currentUserId,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return Expanded(
      child: ColoredBox(
        color: const Color.fromARGB(85, 235, 208, 187),
        child: ChatMessageList(
          docs: docs,

          currentUserId: currentUserId,
          selectedMessageIds: selectedMessageIds,
          isSelectionMode: _isSelectionMode,
          scrollController: _scrollController,
          onToggleSelection: _toggleSelection,
        ),
      ),
    );
  }

  Future<void> copySelectedMessages() async {
    final selectedMessages = _lastDocs
        .where((doc) => selectedMessageIds.contains(doc.id))
        .map((doc) => doc.data())
        .toList();

    final text = selectedMessages
        .map((message) => message['text'] ?? '')
        .join('\n');

    await Clipboard.setData(ClipboardData(text: text));
    _clearSelection();
  }

  Widget _buildComposer() {
    if (_isSelectionMode) return const SizedBox();

    return ChatComposer(
      controller: _messageController,
      onSend: (text) {
        final currentUserId = _currentUserId;
        if (currentUserId == null) return;
        _messagesBloc.add(
          SendMessage(
            chatId: _chatDocId(widget.userId, currentUserId),
            recipientId: widget.userId,
            text: text,
          ),
        );
        _scrollToBottom();
      },
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return ChatSelectionAppBar(
      onCopy: copySelectedMessages,
      selectedCount: selectedMessageIds.length,
      onClose: _clearSelection,
      onDelete: () {},
    );
  }

  bool _shouldScrollToBottom(int currentLength) {
    return currentLength > _lastMessageCount || _lastMessageCount == 0;
  }

  PreferredSizeWidget _buildChatAppBar() {
    final currentUserId = _currentUserId;
    return ChatAppBar(
      userName: widget.numName,
      isOnline: widget.isOnline,
      avatarUrl: widget.imageAvatar,
      chatId: _chatDocId(widget.userId, currentUserId!),
      currentUserId: currentUserId,
    );
  }
}
