abstract class ILoginUserDataRepository {
  Future<bool> checkEnteredDate(String userLogin, String userPassword) async {
    return true;
  }

  Future<Map<String, dynamic>> getEnteredUser(
      String userLogin, String userPassword) async {
    Map<String, dynamic> userDate = {};
    return userDate;
  }
}
