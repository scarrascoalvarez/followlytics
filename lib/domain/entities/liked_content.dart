import 'package:equatable/equatable.dart';

class LikedContent extends Equatable {
  final String author;
  final String? postUrl;
  final DateTime timestamp;

  const LikedContent({
    required this.author,
    this.postUrl,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [author, postUrl, timestamp];
}

