class UserModel {
  String? name;
  String? email;
  String? image;
  String? id;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.image,
  });

  UserModel.fromJson({required Map<String, dynamic> data}) {
    name = data['name'];
    email = data['email'];
    image = data['imageUrl'];
    id = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'imageUrl': image,
      'userId': id,
    };
  }
}
