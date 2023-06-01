class UserAuthResponse {
  UserAuthResponse(
      {required this.email, required this.password, required this.csrftoken, required this.sessionid});
  String email, password, csrftoken,sessionid;
}
