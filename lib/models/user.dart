import 'package:json_annotation/json_annotation.dart';
import 'package:lextorah_chat_bot/utils/roles.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id; // from `sub`
  final String email;
  final UserRole role;
  final DateTime tokenExpiresAt;
  final DateTime trialEndsAt;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.tokenExpiresAt,
    required this.trialEndsAt,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // CopyWith method
  User copyWith({
    String? id, // from `sub`
    String? email,
    UserRole? role,
    DateTime? tokenExpiresAt,
    DateTime? trialEndsAt,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      token: token ?? this.token,
    );
  }
}
