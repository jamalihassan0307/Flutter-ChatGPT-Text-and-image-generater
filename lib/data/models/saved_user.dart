class SavedUser {
  final String email;
  final String password;
  final String? name;
  final DateTime savedAt;

  SavedUser({
    required this.email,
    required this.password,
    this.name,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedUser.fromJson(Map<String, dynamic> json) => SavedUser(
    email: json['email'],
    password: json['password'],
    name: json['name'],
    savedAt: DateTime.parse(json['savedAt']),
  );
} 