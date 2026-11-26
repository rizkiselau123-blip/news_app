class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
  });

  final int id;
  final String name;
  final String email;
  final String company;

  factory User.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>;
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      company: company['name'] as String,
    );
  }
}
