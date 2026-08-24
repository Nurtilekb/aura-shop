// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    this.email = '',

    required this.createdAt,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',

      createdAt: parseDateTime(json['createdAt']),
      isAdmin: json['isAdmin'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,

      'createdAt': createdAt.toIso8601String(),
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isOnline,
    DateTime? lastSeen,
    String? phoneNumber,
    String? status,
    DateTime? createdAt,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,

      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  List<Object?> get props => [id, name, email, createdAt, isAdmin];
}
