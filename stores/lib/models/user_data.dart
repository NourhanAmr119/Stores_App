class UserData {
  final int? id;
  final String name;
  final String email;
  final String password;
  

  UserData({
    this.id,
    required this.name,
    required this.email,
    required this.password,  
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      password: map['password'],
        
    );
  }
}