import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  final String? currentUserId;
  final Set<String> selectedMessageIds;
  final bool isSelectionMode;
  final ScrollController scrollController;
  final void Function(String id) onToggleSelection;

  const ChatMessageList({
    super.key,
    required this.docs,
    required this.currentUserId,
    required this.selectedMessageIds,
    required this.isSelectionMode,
    required this.scrollController,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return Center(child: Text('Сообщений пока нет'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: docs.length,
      itemBuilder: (_, index) {
        final doc = docs[index];
        final message = doc.data();
        final isMe = message['senderId'] == currentUserId;

        final createdAt = message['createdAt'];

        String timeText = '';

        if (createdAt is Timestamp) {
          final dateTime = createdAt.toDate().toLocal();

          timeText =
              '${dateTime.hour.toString().padLeft(2, '0')}:'
              '${dateTime.minute.toString().padLeft(2, '0')}';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          color: Colors.transparent,
          child: ChatMessageBubble(
            text: message['text'] ?? '',
            isMe: isMe,
            time: timeText,
            onlongTap: () => onToggleSelection(doc.id),
            ontapp: () {
              if (isSelectionMode) {
                onToggleSelection(doc.id);
              }
            },
          ),
        );
      },
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final VoidCallback onlongTap;
  final VoidCallback ontapp;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.onlongTap,
    required this.ontapp,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String limitEmptyLines(String text) {
      return text.replaceAll(RegExp(r'\n{4,}'), '\n\n\n');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onLongPress: onlongTap,
                onTap: ontapp,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, offset: const Offset(0, 1)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        limitEmptyLines(text),
                        style: TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      Text(time, style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String text) onSend;

  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);
    return ColoredBox(
      color: colors.cardColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: AppInputWidget(
                maxLines: 3,
                controller: controller,
                radius: 25,
                borderColor: colors.dividerColor,
                hintText: 'Сообщение',
                filledColor: colors.hoverColor,
              ),
            ),
            const SizedBox(width: 8),
            _buildSendButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(ThemeData color) {
    return Container(
      decoration: BoxDecoration(
        color: color.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          final text = controller.text.trim();
          if (text.isEmpty) return;
          onSend(text);
          controller.clear();
        },
        icon: Icon(Icons.send, color: color.canvasColor, size: 20),
      ),
    );
  }
}

class ChatSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  const ChatSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    required this.onDelete,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      title: Text('$selectedCount'),
      actions: [
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            onCopy();
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final bool isOnline;
  final String avatarUrl;
  final String chatId;
  final String currentUserId;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.isOnline,
    required this.avatarUrl,
    required this.chatId,
    required this.currentUserId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      elevation: 0,
      titleSpacing: 0,
      actionsPadding: const EdgeInsets.only(right: 8),
      actions: [
        PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(
            Icons.more_vert_outlined,
            size: 29,
            color: Colors.greenAccent,
          ),
          onSelected: (value) {
            // if (value != 'clear') return;
            // showConfirmDialog(
            //   context,
            //   title: 'clearchat'.tr(),
            //   content: 'clearchatconfirm'.tr(),
            //   cancelText: 'cancel'.tr(),
            //   confirmText: 'clear'.tr(),
            // ).then((confirmed) {
            //   if (confirmed != true) return;
            //   if (!context.mounted) return;
            //   context.read<MessagesBloc>().add(
            //     ClearChat(chatId: chatId, currentUserId: currentUserId),
            //   );
            // });
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'clear',
              child: Row(
                children: [
                  const Icon(Icons.delete_sweep_outlined, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'clearchat',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      title: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          _buildUserInfo(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).dividerColor,
          ),
          child: avatarUrl.isEmpty
              ? Center(
                  child: Text(
                    getInitials(userName),
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              : null,
        ),
        if (isOnline == true)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ),
        Text(
          'online',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.green),
        ),
      ],
    );
  }

  String getInitials(String fullName) {
    if (fullName.isEmpty) return '';

    final parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
