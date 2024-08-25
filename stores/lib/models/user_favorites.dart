class UserFavorites {
  final String userEmail;
  final int storeId;

  UserFavorites({required this.userEmail, required this.storeId});

  // Convert UserFavorites object to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_email': userEmail,
      'store_id': storeId,
    };
  }

  // Create a UserFavorites object from a Map
  static UserFavorites fromMap(Map<String, dynamic> map) {
    return UserFavorites(
      userEmail: map['user_email'],
      storeId: map['store_id'],
    );
  }
}