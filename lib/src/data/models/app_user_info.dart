// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppUserInfo {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final bool? isProfileSetupComplete;
  AppUserInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.isProfileSetupComplete,
  });

  AppUserInfo copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
  }) {
    return AppUserInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? imageUrl,
    );
  }

  factory AppUserInfo.fromMap(Map<String, dynamic> map) {
    return AppUserInfo(
        id: map['id'] != null ? map['id'] as int : null,
        name: map['name'] != null ? map['name'] as String : null,
        email: map['email'] != null ? map['email'] as String : null,
        phone: map['phone'] != null ? map['phone'] as String : null,
        imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
        isProfileSetupComplete: map['isProfileSetupComplete'] != null
            ? map['isProfileSetupComplete'] as bool
            : null);
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant AppUserInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ phone.hashCode;
  }
}
