class AuthController {
  const AuthController();

  bool isValidEmail(String email) => RegExp(r'^[\w.!#$%&’*+/=?^`{|}~-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);

  bool isValidPassword(String password) => password.trim().length >= 6;
}
