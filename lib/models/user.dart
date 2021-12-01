class User {
  final String userBsc;
  final double userBalance;

  User({required this.userBsc, required this.userBalance});
  factory User.fromMap(Map<String, dynamic> data) {
    return User(userBsc: data['userBsc'], userBalance: data['userBalance']);
  }
  Map<String, dynamic> toMap() {
    return {'userBsc': userBsc, 'userBalance': userBalance};
  }
}
