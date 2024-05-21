class user {
  List<String>? followList;
  List<String>? followingList;
  List<String>? Likepost;

  String? bio;
  String? dob;
  String? name;
  List<String>? postlist;
  String? imgurl;
  String? username;
  user(
      {this.Likepost,
      this.imgurl,
      this.bio,
      this.dob,
      this.followList,
      this.followingList,
      this.name,
      this.postlist,
      this.username});
}
