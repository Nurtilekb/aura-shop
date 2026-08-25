import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/chat_items_model.dart';
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
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final List<String> _filters = ['Все', 'Открытые · 3', 'Закрытые'];

  final List<ChatItemData> _chats = const [
    ChatItemData(
      initials: 'АС',
      avatarBgColor: Color(0xFF5A49F8),
      isOnline: true,
      name: 'Анна Соколова',
      time: '2 мин',
      lastMessage: 'Где мой заказ #AU-24815?',
      unreadCount: 2,
    ),

    ChatItemData(
      initials: 'АС',
      avatarBgColor: Color(0xFF5A49F8),
      isOnline: true,
      name: 'Анна Соколова',
      time: '2 мин',
      lastMessage: 'Где мой заказ #AU-24815?',
      unreadCount: 2,
    ),

    ChatItemData(
      initials: 'МК',
      avatarBgColor: Color(0xFF387B5B),
      isOnline: false,
      name: 'Мария Кузнецова',
      time: '1 ч',
      lastMessage: 'Спасибо, всё пришло вовремя!',
      unreadCount: 0,
    ),
  ];

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

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _chats.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: borderColor),
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        return _ChatTile(chat: chat);
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
  final ChatItemData chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);

    return InkWell(
      onTap: () {
        context.router.push(InsidechatRoute());
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
                  backgroundColor: chat.avatarBgColor,
                  child: Text(
                    chat.initials,
                    style: TextStyle(
                      color: chat.avatarTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (chat.isOnline)
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
                      color: chat.isClosed
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
                  chat.time,
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
