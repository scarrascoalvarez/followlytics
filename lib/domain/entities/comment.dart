import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String mediaOwner;
  final String content;
  final DateTime timestamp;

  const Comment({
    required this.mediaOwner,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [mediaOwner, content, timestamp];
}

