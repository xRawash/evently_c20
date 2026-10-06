class UserModel {
  static UserModel? loggedInUser;
  String name;
  String id;
  String email;

  UserModel({
    required this.name,
    required this.id,
    required this.email,
});
  UserModel.fromJson(Map<String, dynamic> json): this(
    name : json['name'],
    id : json['id'],
    email : json['email']);

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'id' : id,
      'email' : email,
    };
  }
}