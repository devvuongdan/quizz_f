import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaskDto {
  final String title;
  final String content;
  final int status;
  TaskDto({
    required this.title,
    required this.content,
    this.status = -1,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'status': status,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) {
    return TaskDto(
      title: map['title'] as String,
      content: map['content'] as String,
      status: map['status'] as int? ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskDto.fromJson(String source) =>
      TaskDto.fromMap(json.decode(source) as Map<String, dynamic>);

  TaskDto copyWith({
    String? title,
    String? content,
    int? status,
  }) {
    return TaskDto(
      title: title ?? this.title,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'TaskDto(title: $title, content: $content, status: $status)';

  @override
  bool operator ==(covariant TaskDto other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.content == content &&
        other.status == status;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode ^ status.hashCode;
}
