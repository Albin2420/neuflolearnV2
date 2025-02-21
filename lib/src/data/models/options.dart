

class Options {
  String? a;
  String? b;
  String? c;
  String? d;

  Options({
    this.a,
    this.b,
    this.c,
    this.d,
  });

  Options copyWith({
    String? a,
    String? b,
    String? c,
    String? d,
  }) {
    return Options(
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'a': a,
      'b': b,
      'c': c,
      'd': d,
    };
  }

  factory Options.fromMap(Map<String, dynamic> map) {
    return Options(
      a: map['A'] != null ? map['A'] as String : null,
      b: map['B'] != null ? map['B'] as String : null,
      c: map['C'] != null ? map['C'] as String : null,
      d: map['D'] != null ? map['D'] as String : null,
    );
  }

  @override
  bool operator ==(covariant Options other) {
    if (identical(this, other)) return true;

    return other.a == a && other.b == b && other.c == c && other.d == d;
  }

  @override
  int get hashCode {
    return a.hashCode ^ b.hashCode ^ c.hashCode ^ d.hashCode;
  }

  @override
  String toString() {
    return 'Options(a: $a, b: $b, c: $c, d: $d)';
  }
}
