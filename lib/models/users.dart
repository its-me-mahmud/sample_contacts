class Users {
  int id;
  String name;
  String post;
  String mobile;

  Users({this.id, this.name, this.post, this.mobile});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    post = json['post'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['post'] = this.post;
    data['mobile'] = this.mobile;
    return data;
  }
}
