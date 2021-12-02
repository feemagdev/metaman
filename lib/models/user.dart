class User {
  final String userBsc;
  final double userBalance;
  final String name;

  User({required this.userBsc, required this.userBalance, required this.name});
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      userBsc: data['userBsc'],
      userBalance: data['userBalance'],
      name: data['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userBsc': userBsc,
      'userBalance': userBalance,
      'name': name,
    };
  }
}
