import 'dart:ui';

import 'package:flutter/material.dart';

class ChatItemData {
  final String initials;
  final Color avatarBgColor;
  final Color avatarTextColor;
  final bool isOnline;
  final String name;
  final String time;
  final String lastMessage;
  final int unreadCount;
  final bool isClosed;

  const ChatItemData({
    required this.initials,
    required this.avatarBgColor,
    this.avatarTextColor = Colors.white,
    required this.isOnline,
    required this.name,
    required this.time,
    required this.lastMessage,
    required this.unreadCount,
    this.isClosed = false,
  });
}
