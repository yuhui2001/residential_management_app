class UserData {
  static UserData? user;

  final String name;
  final String address;
  final String userid;
  String monthlyPaymentStatus;

  UserData({
    required this.name,
    required this.address,
    required this.userid,
    required this.monthlyPaymentStatus,
  });
}
