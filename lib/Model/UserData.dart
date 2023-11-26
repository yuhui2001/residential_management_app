class UserData {
  static UserData? user; // change the type to UserData

  final String name;
  final String address;
  final String userid;
  final String monthlyPaymentStatus;

  UserData(
      {required this.name,
      required this.address,
      required this.userid,
      required this.monthlyPaymentStatus});
}
