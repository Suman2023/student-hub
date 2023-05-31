class UserAuthResponse {
  UserAuthResponse(
      {required this.email, required this.password, required this.csrftoken});
  String email, password, csrftoken;
}
