import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/repositories/chat_repository.dart';
import 'package:aurashop/shared/models/chat_model.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/chip_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SupportChatsScreen extends StatefulWidget {
  const SupportChatsScreen({super.key});

  @override
  State<SupportChatsScreen> createState() => _SupportChatsScreenState();
}

class _SupportChatsScreenState extends State<SupportChatsScreen> {
  int _selectedFilterIndex = 0;
  final _textController = TextEditingController();
  final _chatRepository = ChatRepository();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final List<String> _filters = ['Все', 'Непрочитанные 3'];

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);
    const borderColor = Color(0xFFEFEFEF);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Чаты поддержки',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: primaryPurple,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              '3 новых',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: AppInputWidget(
                        controller: _textController,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        filledColor: Colors.transparent,
                        leading: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF00B2FF),
                          size: 22,
                        ),
                        hintText: 'Поиск по диалогам',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ChipList(
                        labels: _filters,
                        selectedIndex: _selectedFilterIndex,
                        onSelected: (index) {
                          setState(() {
                            _selectedFilterIndex = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    StreamBuilder<List<Chat>>(
                      stream: _chatRepository.streamChats(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Не удалось загрузить чаты'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final query = _textController.text.trim().toLowerCase();
                        final chats = (snapshot.data ?? const <Chat>[]).where((
                          chat,
                        ) {
                          final matchesSearch =
                              query.isEmpty ||
                              chat.name.toLowerCase().contains(query) ||
                              chat.lastMessage.toLowerCase().contains(query);
                          final matchesFilter =
                              _selectedFilterIndex == 0 ||
                              (_selectedFilterIndex == 1 &&
                                  chat.unreadCount > 0);
                          return matchesSearch && matchesFilter;
                        }).toList();

                        if (chats.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Новых сообщений пока нет',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight(700),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chats.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, color: borderColor),
                          itemBuilder: (context, index) =>
                              _ChatTile(chat: chats[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Chat chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);

    return InkWell(
      onTap: () {
        context.router.push(
          ChatsRoute(
            numName: chat.name,
            isOnline: true,
            imageAvatar: chat.avatarUrl,
            userId: chat.otherUserId,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF5A49F8),
                  child: Text(
                    _getInitials(chat.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (chat.status == ChatStatus.active)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: chat.status == ChatStatus.archived
                          ? const Color(0xFF8E8E93)
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(chat.time),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 6),
                if (chat.unreadCount > 0)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _getInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String _formatTime(DateTime time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}
