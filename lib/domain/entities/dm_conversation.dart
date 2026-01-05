import 'package:equatable/equatable.dart';

/// Represents a DM conversation with a user
class DmConversation extends Equatable {
  final String username;
  final int messageCount;
  final DateTime? lastMessageDate;

  const DmConversation({
    required this.username,
    required this.messageCount,
    this.lastMessageDate,
  });

  @override
  List<Object?> get props => [username, messageCount, lastMessageDate];
}

