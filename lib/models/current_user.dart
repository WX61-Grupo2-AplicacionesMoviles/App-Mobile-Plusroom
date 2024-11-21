class CurrentUser {
  static final CurrentUser _instancia = CurrentUser._();

  factory CurrentUser() => _instancia;

  CurrentUser._();

  int? id;
  String? role;

  void setId(int newId) => id = newId;
  int? getId() => id;

  void setRole(String newRole) => role = newRole;
  String? getRole() => role;
}