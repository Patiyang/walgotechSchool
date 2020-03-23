class User {
  int id;
  String userName;
  String firstName;
  String lastName;
  String password;
  String phoneNumber;

  User({this.id, this.userName, this.password, this.firstName, this.lastName,this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json['id'],
        userName: json['userName'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userName':userName,
        'password':password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber':phoneNumber
      };
}
