class UserModel {
  final String userId;
  final String userName;
  final String createdAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  UserModel copyWith({
    String? userId,
    String? userName,
    String? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      userId: jsonData['userId'] as String? ?? '',
      userName: jsonData['username'] as String? ?? '',
      createdAt: jsonData['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': userName,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return ''''
        userId : $userId,
        username : $userName,
        createdAt : $createdAt, 
      ''';
  }
}
