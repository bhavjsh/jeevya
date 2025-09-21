class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? abhaId;
  final List<String> medicalConditions;
  final List<String> allergies;
  final String? emergencyContact;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.abhaId,
    this.medicalConditions = const [],
    this.allergies = const [],
    this.emergencyContact,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      gender: json['gender'],
      address: json['address'],
      abhaId: json['abhaId'],
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      emergencyContact: json['emergencyContact'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
      'abhaId': abhaId,
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? abhaId,
    List<String>? medicalConditions,
    List<String>? allergies,
    String? emergencyContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      abhaId: abhaId ?? this.abhaId,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}