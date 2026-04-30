enum RoleType {
  gerente,
  cocinero,
  repartidor,
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final RoleType role;
  final String? password; // Agregado para validación local

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: RoleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => RoleType.gerente,
      ),
      password: json['password'],
    );
  }
}
