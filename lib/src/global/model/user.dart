enum UserRole { user, admin }

class User {
  int id,updateCnt;
  String fullname;
  String email;
  String? phone;
  DateTime? dob;
  String? address, country;
  int? locationId;
  UserRole role;
  bool isVerified;
  DateTime? updatedAt;
  DateTime? createdAt;

  User({
    this.id = 0,
    this.fullname = "Guest",
    this.email = "",
    this.phone,
    this.dob,
    this.address,
    this.updateCnt=0,
    this.country,
    this.locationId,
    this.role = UserRole.user,
    this.isVerified = false,
    this.updatedAt,
    this.createdAt,
  });

  String get initials {
    return fullname.isNotEmpty
        ? fullname
            .trim()
            .split(' ')
            .map((e) => e[0].toUpperCase())
            .take(2)
            .join()
        : '';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      address: json['address'],
      country: json['country'],
      locationId: json['locationid'],
      isVerified: json['isverified'],
      updateCnt: json['updatecnt'] ?? 0,
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'email': email,
        'phone': phone,
        'dob': dob?.toIso8601String(),
        'address': address,
        'country': country,
        'locationid': locationId,
        'role': role == UserRole.admin ? 'admin' : 'user',
      };
}
