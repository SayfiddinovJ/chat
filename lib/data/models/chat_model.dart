class ChatModel {
  final String chatId;
  final String userName;
  final String massage;
  final String createdAt;

  ChatModel({
    required this.chatId,
    required this.userName,
    required this.massage,
    required this.createdAt,
  });

  ChatModel copyWith({
    String? chatId,
    String? userName,
    String? massage,
    String? createdAt,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      userName: userName ?? this.userName,
      massage: massage ?? this.massage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> jsonData) {
    return ChatModel(
      chatId: jsonData['chatId'] as String? ?? '',
      userName: jsonData['username'] as String? ?? '',
      massage: jsonData['massage'] as String? ?? '',
      createdAt: jsonData['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'username': userName,
      'massage': massage,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return ''''
        chatId : $chatId,
        username : $userName,
        massage : $massage,
        createdAt : $createdAt, 
      ''';
  }
}
