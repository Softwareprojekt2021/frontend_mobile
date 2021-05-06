//TODO Check json fields if login backend has been implemented
class User {
  int id, admin;
  String email, firstName, lastName, course, profilePicture, university;

  User(this.id, this.email, this.firstName, this.lastName, this.course, this.profilePicture, this.university, this.admin);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        profilePicture = json['profile_picture'],
        university = json['university.university'],
        admin = json['admin'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'course': course,
    'profile_picture': profilePicture,
    'university': university,
    'admin': admin
  };
}