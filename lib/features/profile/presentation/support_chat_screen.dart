import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<_MessageItem> _messages = [
    _MessageItem.text(
      text: 'Здравствуйте, Анна! 👋 Чем можем помочь?',
      isMe: false,
    ),
    _MessageItem.text(
      text: 'Здравствуйте! Где мой заказ #AU-24815?',
      isMe: true,
    ),
    _MessageItem.text(
      text: 'Заказ уже в пути 🚚 Курьер доставит завтра с 10:00 до 22:00.',
      isMe: false,
    ),
    _MessageItem.order(orderNumber: '#AU-24815'),
    _MessageItem.text(text: 'Спасибо! 🙏', isMe: true),
    _MessageItem.typing(),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary.withOpacity(0.8),
                  child: const Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Поддержка AURA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'онлайн · отвечаем за минуту',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Сегодня',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ..._messages.map((msg) => _ChatBubble(message: msg)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
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

                      borderColor: colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          _messages.add(
                            _MessageItem.text(text: text, isMe: true),
                          );
                          _messageController.clear();
                        });
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _MessageItem message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: message.type == _MessageType.order
            ? const EdgeInsets.all(12)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isMe ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            if (!message.isMe)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
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
      case _MessageType.text:
        return Text(
          message.text ?? '',
          style: TextStyle(
            fontSize: 15,
            height: 1.35,
            color: message.isMe ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        );
      case _MessageType.typing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case _MessageType.order:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
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
                  onTap: () {},
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
        );
    }
  }
}

enum _MessageType { text, typing, order }

class _MessageItem {
  final String? text;
  final String? orderNumber;
  final bool isMe;
  final _MessageType type;

  _MessageItem.text({required this.text, required this.isMe})
    : orderNumber = null,
      type = _MessageType.text;

  _MessageItem.typing()
    : text = null,
      orderNumber = null,
      isMe = false,
      type = _MessageType.typing;

  _MessageItem.order({required this.orderNumber})
    : text = null,
      isMe = false,
      type = _MessageType.order;
}
