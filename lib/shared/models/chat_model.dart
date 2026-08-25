// lib/features/chat/models/chat_message.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum MessageType { text, order, typing, system }

class ChatMessage extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final String? orderNumber;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  final String? imageUrl;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    this.orderNumber,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
    this.imageUrl,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      orderNumber: data['orderNumber'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => MessageType.text,
      ),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'orderNumber': orderNumber,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type.toString(),
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    String? senderId,
    String? orderNumber,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
    String? imageUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      orderNumber: orderNumber ?? this.orderNumber,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    senderId,
    orderNumber,
    timestamp,
    type,
    isRead,
    imageUrl,
  ];
}

// lib/features/chat/models/chat.dart
class Chat extends Equatable {
  final String id;
  final String userId;
  final String? adminId;
  final List<String> participantIds;
  final ChatStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.userId,
    this.adminId,
    required this.participantIds,
    this.status = ChatStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      userId: data['userId'] ?? '',
      adminId: data['adminId'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      status: ChatStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => ChatStatus.active,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
      unreadCount: data['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'adminId': adminId,
      'participantIds': participantIds,
      'status': status.toString(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? FieldValue.serverTimestamp()
          : null,
      'unreadCount': unreadCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    adminId,
    participantIds,
    status,
    createdAt,
    updatedAt,
  ];
}

enum ChatStatus { active, resolved, closed }
