class PostModel {
   String ? caption =''  ;
   List ? postImages = [];
   int photoIndex = 1;
   String ? dateTime  ;
   String ? name;
   String ? uid;
   String  ? image;
   String ? postUid;
   bool ? isLiked = false  ;
   int  ? likes = 0;
   int  ? comments = 0;

  PostModel({this.caption, this.name, this.dateTime, this.image, this.uid,
      this.postImages, this.postUid, this.isLiked , this.likes});

  PostModel.FromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    postImages = json['postImages'] as List ;
    dateTime = json['dateTime'];
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
  }
  Map<String, dynamic> toJosn() {
    return {
      'caption': caption,
      'postImages': postImages,
      'dateTime': dateTime,
      'name': name,
      'uid': uid,
      'image': image,
    };
  }
}
