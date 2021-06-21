class User {
  int id;
  bool admin;
  String email, firstName, lastName, course, profilePicture, university, password;

  User({this.id, this.email, this.password, this.firstName, this.lastName, this.course, this.profilePicture, this.university, this.admin});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['e_mail'],
        password = json['password'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        profilePicture = json['profile_picture'],
        university = json['university'],
        admin = json['admin'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'e_mail': email,
    if(password.isNotEmpty) 'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'course': course,
    'profile_picture': profilePicture,
    'university': university,
    'admin': admin
  };

  User clone() => User(id: id, email: email, password: password, firstName: firstName, lastName: lastName, course: course, profilePicture: profilePicture, university: university, admin: admin);
}