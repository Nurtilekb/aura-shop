import 'package:aurashop/bloc/support_chat/cubit/chat_cubit.dart';
import 'package:aurashop/repositories/chat_repository.dart';
import 'package:aurashop/shared/models/chat_model.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class InsideChatScreen extends StatefulWidget {
  const InsideChatScreen({super.key, this.userId, this.chatId});
  final String? userId;
  final String? chatId;
  @override
  State<InsideChatScreen> createState() => _InsideChatScreenState();
}

class _InsideChatScreenState extends State<InsideChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    final cubit = context.read<ChatCubit>();
    if (widget.chatId != null) {
      await cubit.loadChatById(widget.chatId!);
    } else {
      final userId =
          widget.userId ?? context.read<ChatRepository>().currentUserId;
      if (userId.isNotEmpty) {
        await cubit.loadChat(userId);
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAdmin = context.read<ChatRepository>().isAdmin;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.8),
              child: Text(
                isAdmin ? 'U' : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdmin ? 'Пользователь' : 'Поддержка AURA',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  buildWhen: (previous, current) =>
                      current is ChatLoaded &&
                      previous is ChatLoaded &&
                      previous.isTyping != current.isTyping,
                  builder: (context, state) {
                    if (state is ChatLoaded && state.isTyping) {
                      return Text(
                        'печатает...',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return Text(
                      'онлайн · отвечаем за минуту',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () => _showCloseChatDialog(),
              icon: Icon(Icons.more_vert),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ошибка загрузки чата',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(color: colorScheme.outline),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadChat,
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is! ChatLoaded) {
                    return const SizedBox.shrink();
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isTyping && index == 0) {
                        return _ChatBubble.typing();
                      }

                      final messageIndex = state.isTyping ? index - 1 : index;
                      if (messageIndex < 0 ||
                          messageIndex >= state.messages.length) {
                        return const SizedBox.shrink();
                      }

                      final message = state.messages[messageIndex];
                      return _ChatBubble(
                        message: message,
                        isMe:
                            message.senderId ==
                            context.read<ChatRepository>().currentUserId,
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => _showAttachmentOptions(context),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              shape: const CircleBorder(),
            ),
            icon: Icon(Icons.add, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppInputWidget(
              filledColor: Colors.transparent,
              hintText: 'Сообщение...',
              controller: _messageController,
              borderColor: colorScheme.outlineVariant.withValues(alpha: 0.5),
              onChanged: (text) {
                final cubit = context.read<ChatCubit>();
                if (text.isNotEmpty && !_isTyping) {
                  _isTyping = true;
                  cubit.setTyping(true);
                } else if (text.isEmpty && _isTyping) {
                  _isTyping = false;
                  cubit.setTyping(false);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () => _sendMessage(context),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final cubit = context.read<ChatCubit>();
    cubit.sendMessage(text: text);
    _messageController.clear();
    _isTyping = false;
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Прикрепить',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentOption(
                    icon: Icons.photo,
                    label: 'Фото',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Открыть галерею
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Камера',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Открыть камеру
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.description,
                    label: 'Документ',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Выбрать документ
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.shopping_bag,
                    label: 'Заказ',
                    onTap: () {
                      Navigator.pop(context);
                      _showOrderInputDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderInputDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Номер заказа'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'AU-24815',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final orderNumber = controller.text.trim();
              if (orderNumber.isNotEmpty) {
                context.read<ChatCubit>().sendMessage(
                  text: 'Заказ $orderNumber',
                  orderNumber: orderNumber,
                  type: MessageType.order,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _showCloseChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Закрыть чат'),
        content: const Text('Вы уверены, что хотите закрыть этот чат?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChatCubit>().closeChat();
              Navigator.pop(context);
              AutoRouter.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  factory _ChatBubble.typing() {
    return _ChatBubble(
      message: ChatMessage(
        id: 'typing',
        text: '',
        senderId: '',
        timestamp: DateTime.now(),
        type: MessageType.typing,
      ),
      isMe: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (message.type == MessageType.typing) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [_Dot(0), _Dot(0.2), _Dot(0.4)],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: message.type == MessageType.order
            ? const EdgeInsets.all(12)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            if (!isMe)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (message.type) {
      case MessageType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
            if (message.imageUrl != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.imageUrl!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe
                    ? colorScheme.onPrimary.withValues(alpha: 0.7)
                    : colorScheme.outline,
              ),
            ),
          ],
        );

      case MessageType.order:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('📦', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Заказ ${message.orderNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: () {
                        // TODO: Перейти к деталям заказа
                      },
                      child: Text(
                        'Отследить →',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message.text,
              style: TextStyle(fontSize: 14, color: colorScheme.outline),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(fontSize: 10, color: colorScheme.outline),
            ),
          ],
        );

      case MessageType.system:
        return Center(
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _Dot extends StatefulWidget {
  final double delay;

  const _Dot(this.delay);

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.3, end: 1), weight: 0.5),
          TweenSequenceItem(tween: Tween(begin: 1, end: 0.3), weight: 0.5),
        ]).animate(_controller)..addListener(() {
          if (mounted) setState(() {});
        });

    // Задержка для каждой точки
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.outline.withValues(alpha: 0.3 + (_animation.value * 0.7)),
        shape: BoxShape.circle,
      ),
    );
  }
}
