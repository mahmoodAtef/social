class CommentModel {
  String? text;
  String? image;
  String? name;
  String? userImage;
  List<CommentModel>? replies = [];

  CommentModel({
    this.text,
    this.image,
    this.name,
    this.replies,
    this.userImage,
  });
  CommentModel.FromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
    name = json['name'];
    userImage = json['userImage'];
    List? repliesMap = json['replies'];
    //  repliesMap!.forEach((element) {replies!.add(CommentModel.FromJson(element));}) ;
  }
  Map<String, dynamic> toJosn() {
    return {
      'text': text,
      'image': image,
      'name': name,
      'replies': replies,
      'userImage': userImage,
    };
  }
}
