class GetUsers {
  int id;
  String title;
  String subtitle;
  String price;
  String validity;

  GetUsers({
    this.id,
  this.title,
  this.subtitle,
  this.price,
  this.validity
  });
  factory GetUsers.fromJson(Map<String, dynamic> json){
    return GetUsers(
      id: json['id'],
    title: json['title'],
    subtitle: json['description'],
    price: json['price'],
    validity: json['validity']);

  }
}