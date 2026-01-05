import 'package:equatable/equatable.dart';

class InstagramProfile extends Equatable {
  final String username;
  final String? href;
  final DateTime? timestamp;

  const InstagramProfile({
    required this.username,
    this.href,
    this.timestamp,
  });

  String get profileUrl => href ?? 'https://www.instagram.com/$username';

  @override
  List<Object?> get props => [username, href, timestamp];

  @override
  String toString() => 'InstagramProfile($username)';
}

