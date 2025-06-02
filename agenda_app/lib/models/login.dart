class Login {
  final String login;
  final String senha;

  Login({required this.login, required this.senha});
}
class LoginRepository {
  static final List<Login> logins = [
    Login(login: "alexandre", senha: "1234"),
    Login(login: "heitor", senha: "4321"),
  ];

  static bool isValid(Login login) => logins.any((admin) => admin.login == login.login && admin.senha == login.senha);
}
