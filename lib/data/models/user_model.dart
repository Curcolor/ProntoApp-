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

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}
