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
  final String negocioId;
  final String? password; // Agregado para validación local

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.negocioId = 'main',
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'negocioId': negocioId,
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
      negocioId: json['negocioId'] as String? ?? 'main',
      password: json['password'],
    );
  }
}
