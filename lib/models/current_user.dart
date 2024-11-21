class CurrentUser{
  static final CurrentUser _instancia = CurrentUser._();

  factory CurrentUser() => _instancia;

  CurrentUser._();

  int? id;
  void setId(int newId) => id = newId;
  int? getId() => id;

}