import 'package:equatable/equatable.dart';

class StoryInteraction extends Equatable {
  final String author;
  final DateTime timestamp;
  final String? value;

  const StoryInteraction({
    required this.author,
    required this.timestamp,
    this.value,
  });

  @override
  List<Object?> get props => [author, timestamp, value];
}

