// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Image {
  String? url;
  String? type;

  Image({
    this.url,
    this.type,
  });

  Image copyWith({
    String? url,
    String? type,
  }) {
    return Image(
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type,
    };
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      url: map['URL'] != null ? map['URL'] as String : null,
      type: map['Type'] != null ? map['Type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Image.fromJson(String source) =>
      Image.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Image(url: $url, type: $type)';

  @override
  bool operator ==(covariant Image other) {
    if (identical(this, other)) return true;

    return other.url == url && other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode;
}
