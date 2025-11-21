class LoginCapsule {
  const LoginCapsule({
    required this.loginMethod,
    required this.homeServer,
    this.username,
    this.password,
  });
  final String loginMethod;
  final String homeServer;
  final String? username;
  final String? password;
}

class LoginTypeCheckCapsule {
  const LoginTypeCheckCapsule({
    required this.loginMethod,
    required this.homeServer,
  });
  final String loginMethod;
  final String homeServer;
}
