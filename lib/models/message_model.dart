class MessageModel {
  String? senderId;
  String? reciverId;
  String? messageId;
  String? createdAt;
  String? content;

  MessageModel({
    this.senderId,
    this.createdAt,
    this.messageId,
    this.reciverId,
    this.content,
  });
  MessageModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    createdAt = json['createdAt'];
    reciverId = json['reciverId'];
    messageId = json['messageId'];
    content = json['content'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'messageId':messageId,
      'reciverId': reciverId,
      'createdAt': createdAt,
      'content': content,
    };
  }
}
