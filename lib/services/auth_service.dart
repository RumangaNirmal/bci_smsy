class AuthService {
  const AuthService();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w.!#$%&’*+/=?^`{|}~-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.trim().length >= 6;
  }
}
