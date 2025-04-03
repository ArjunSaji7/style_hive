class UserDetails {
  String name;
  String phone;
  String gender;
  String imagePath;

  UserDetails({
    this.name = '',
    this.phone = '',
    this.gender = '',
    this.imagePath = '',
  });
}

// Global instance
UserDetails currentUser = UserDetails();
