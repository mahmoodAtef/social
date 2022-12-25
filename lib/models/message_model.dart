class MessageModel {
  String? text;
  String? image;
  String? senderId;
  String? receiverId;
  String? dateTime;

  MessageModel({
    this.text,
    this.image,
    this.senderId,
    this.dateTime,
    this.receiverId,
  });
  MessageModel.FromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    //  repliesMap!.forEach((element) {replies!.add(CommentModel.FromJson(element));}) ;
  }
  Map<String, dynamic> toJosn() {
    return {
      'text': text,
      'image': image,
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime
    };
  }
}
