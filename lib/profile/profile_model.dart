enum ProfileStatus { legioner, teamlead, admin }
enum EmployeeStatus { initial, ill, vacation, remote, office }
enum Gender { male, female }
enum ContactType {
  telegram,
  skype,
  slack,
}

class Contact {
  ContactType type;
  String contact;

  Contact({required this.type, required this.contact});
}

class Profile {
  final int id;

  final String name;
  final String surname;
  final String patronymic;

  final EmployeeStatus status;

  final String? avatar;

  final String email;
  final String? phone;
  final String? addPhone;

  final ProfileStatus role;
  final String? department;

  final String? dateOfEmployement;
  final String? firstDayOnWork;

  final Gender gender;
  final String? birthdate;

  final List<Contact>? contacts;

  Profile(
      {required this.id,
      required this.name,
      required this.surname,
      required this.patronymic,
      required this.email,
      this.status = EmployeeStatus.initial,
      required this.role,
      required this.gender,
      this.avatar,
      this.phone,
      this.addPhone,
      this.dateOfEmployement,
      this.department,
      this.firstDayOnWork,
      this.birthdate,
      this.contacts});

  Profile.empty(this.id,
      {this.avatar,
      this.status = EmployeeStatus.initial,
      this.phone,
      this.addPhone,
      this.department,
      this.dateOfEmployement,
      this.firstDayOnWork,
      this.birthdate,
      this.contacts})
      : name = '',
        surname = '',
        patronymic = '',
        email = '',
        role = ProfileStatus.legioner,
        gender = Gender.male;

  Profile copyWith({String? avatar, String? phone, String? birthdate}) {
    return Profile(
        name: name,
        surname: surname,
        id: id,
        email: email,
        gender: gender,
        patronymic: patronymic,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        birthdate: birthdate ?? this.birthdate,
        role: role);
  }
}
