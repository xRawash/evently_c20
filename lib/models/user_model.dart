class UserModel {
  static UserModel? loggedInUser;
  String name;
  String id;
  String email;
  List<String> favEvents;

  UserModel({
    required this.name,
    required this.id,
    required this.email,
    List<String>? favEvents,
  }) : favEvents = favEvents ?? [];

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
    name: json['name'] ,
    id: json['id'] ,
    email: json['email'] ,
    favEvents: (json['favEvents'] as List<dynamic>?)?.cast<String>().toList() ?? [],
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'favEvents': favEvents,
    };
  }
}