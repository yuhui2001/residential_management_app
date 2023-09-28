class UserData {
  static UserData? user; // Change the type to UserData

  final String username;
  final String name;
  final String address;
  final String userid;

  UserData(
      {required this.username,
      required this.name,
      required this.address,
      required this.userid});
}
