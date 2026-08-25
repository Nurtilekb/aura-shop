// lib/features/chat/repositories/chat_repository.dart
import 'package:aurashop/shared/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получить ID текущего пользователя
  String get currentUserId => _auth.currentUser?.uid ?? '';
  bool get isAdmin => _auth.currentUser?.email?.contains('admin') ?? false;

  // Получить или создать чат
  Future<Chat> getOrCreateChat(String userId) async {
    final chatRef = _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .limit(1);

    final snapshot = await chatRef.get();
    final matchingDocs = snapshot.docs.where((doc) {
      final data = doc.data();
      final participantIds = List<String>.from(data['participantIds'] ?? []);
      return participantIds.contains(userId);
    });

    if (matchingDocs.isNotEmpty) {
      return Chat.fromFirestore(matchingDocs.first);
    }

    // Создать новый чат
    final newChat = Chat(
      id: '', // будет присвоено Firestore
      userId: userId,
      participantIds: {userId, currentUserId}.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('chats')
        .add(newChat.toFirestore());
    return Chat.fromFirestore(await docRef.get());
  }

  Future<Chat> getChatById(String chatId) async {
    final doc = await _firestore.collection('chats').doc(chatId).get();
    if (!doc.exists) {
      throw Exception('Чат не найден');
    }
    return Chat.fromFirestore(doc);
  }

  // Получить все чаты пользователя
  Stream<List<Chat>> getUserChats() {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList(),
        );
  }

  // Отправить сообщение
  Future<void> sendMessage({
    required String chatId,
    required String text,
    String? orderNumber,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    final message = ChatMessage(
      id: '',
      text: text,
      senderId: currentUserId,
      orderNumber: orderNumber,
      timestamp: DateTime.now(),
      type: type,
      imageUrl: imageUrl,
    );

    final batch = _firestore.batch();

    // Добавить сообщение
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();
    batch.set(messageRef, message.toFirestore());

    // Обновить информацию о чате
    final chatRef = _firestore.collection('chats').doc(chatId);
    batch.update(chatRef, {
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      // Если сообщение от пользователя, увеличиваем счетчик для админа
      'unreadCount': isAdmin ? 0 : FieldValue.increment(1),
    });

    await batch.commit();
  }

  // Получить сообщения чата
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromFirestore(doc))
              .toList(),
        );
  }

  // Отметить сообщения как прочитанные
  Future<void> markMessagesAsRead(String chatId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: currentUserId)
        .get();

    final batch = _firestore.batch();
    for (final doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();

    // Сбросить счетчик непрочитанных
    await _firestore.collection('chats').doc(chatId).update({'unreadCount': 0});
  }

  // Отправить статус "печатает"
  Future<void> sendTypingStatus(String chatId, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).update({
      'userTyping': isTyping,
      'typingTimestamp': FieldValue.serverTimestamp(),
    });
  }

  // Получить статус "печатает"
  Stream<bool> getTypingStatus(String chatId) {
    return _firestore.collection('chats').doc(chatId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return false;
      final isTyping = data['userTyping'] ?? false;
      final timestamp = data['typingTimestamp'] as Timestamp?;

      // Если прошло больше 3 секунд, считаем что перестал печатать
      if (timestamp != null && isTyping) {
        final diff = DateTime.now().difference(timestamp.toDate());
        if (diff.inSeconds > 3) {
          return false;
        }
      }
      return isTyping;
    });
  }

  // Закрыть чат (только для админа)
  Future<void> closeChat(String chatId) async {
    await _firestore.collection('chats').doc(chatId).update({
      'status': ChatStatus.closed.toString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
