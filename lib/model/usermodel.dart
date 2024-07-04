class UserModel {
  final String name;
  final String email;
  final String profilePic;
  final String uid;
  final String banner;
  final bool isAuthenticated;
  final DateTime dateTime;
  final List<String> awards;
  final int karma;

  UserModel({
    required this.awards,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.uid,
    required this.banner,
    required this.isAuthenticated,
    required this.dateTime,
    required this.karma,
  });
   UserModel copyWith({
    String? name,
    String? email,
    String? profilePic,
    String? uid,
    String? banner,
    bool? isAuthenticated,
    DateTime? dateTime,
    List<String>? awards,
    int? karma,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      dateTime: dateTime ?? this.dateTime,
      awards: awards ?? this.awards,
      karma: karma ?? this.karma,
    );
  }

  // Convert a UserModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'uid': uid,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'dateTime': dateTime.toIso8601String(), // Convert DateTime to ISO string
      'awards': awards, // List of strings
      'karma': karma,
    };
  }

  // Create a UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      banner: map['banner'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      dateTime: DateTime.parse(map['dateTime'] ?? DateTime.now().toIso8601String()), // Parse ISO string to DateTime
      awards: List<String>.from(map['awards'] ?? []), // Convert dynamic list to List<String>
      karma: map['karma'] ?? 0,
    );
  }
}