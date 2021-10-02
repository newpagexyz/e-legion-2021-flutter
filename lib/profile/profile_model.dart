enum ProfileStatus {
  admin,
  teamlead,
  legioner,
}
enum EmployeeStatus { initial, ill, vacation, remote, office }
enum Gender { male, female }

class Profile {
  String get profileStatusToString {
    switch (role) {
      case ProfileStatus.legioner:
        return 'Легионер';
      case ProfileStatus.teamlead:
        return 'Тимлид';
      case ProfileStatus.admin:
        return 'Руководитель';
    }
  }

  String get genderString {
    switch (gender) {
      case Gender.male:
        return 'Мужской';
      case Gender.female:
        return 'Женский';
    }
  }

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
  final String? post;
  final String? department;

  final String? dateOfEmployement;
  final String? firstDayOnWork;

  final Gender gender;
  final String? birthdate;

  final String? skype;
  final String? telegram;
  final String? cv;

  Profile(
      {required this.id,
      required this.name,
      required this.surname,
      required this.patronymic,
      required this.email,
      this.status = EmployeeStatus.initial,
      this.post,
      required this.role,
      required this.gender,
      this.avatar,
      this.phone,
      this.addPhone,
      this.dateOfEmployement,
      this.department,
      this.firstDayOnWork,
      this.birthdate,
      this.skype,
      this.cv,
      this.telegram});

  Profile.empty(this.id,
      {this.avatar,
      this.status = EmployeeStatus.initial,
      this.phone,
      this.addPhone,
      this.post,
      this.department,
      this.dateOfEmployement,
      this.firstDayOnWork,
      this.birthdate,
      this.cv,
      this.skype,
      this.telegram})
      : name = '',
        surname = '',
        patronymic = '',
        email = '',
        role = ProfileStatus.legioner,
        gender = Gender.male;

  Profile copyWith(
      {String? avatar,
      String? phone,
      String? birthdate,
      String? skype,
      String? telegram,
      String? cv}) {
    return Profile(
        name: name,
        surname: surname,
        id: id,
        email: email,
        gender: gender,
        patronymic: patronymic,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        cv: cv ?? this.cv,
        birthdate: birthdate ?? this.birthdate,
        skype: skype ?? this.skype,
        telegram: telegram ?? this.telegram,
        role: role);
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: int.parse(json['id']),
        email: json['email'] ?? '',
        name: json['name'],
        post: json['post'],
        surname: json['surname'] ?? '',
        patronymic: json['patronymic'] ?? '',
        phone: json['phone'],
        department: json['sub_company'] ?? '',
        telegram: json['telegram'],
        skype: json['skype'],
        dateOfEmployement: json['work_start'],
        firstDayOnWork: json['work_start_here'],
        avatar: json['avatar'],
        cv: json['cv'],
        addPhone: json['emerge_phone'],
        gender: Gender.values[int.tryParse(json['sex'] ?? '0') ?? 0],
        role: ProfileStatus.values[int.tryParse(json['role'] ?? '0') ?? 0]);
  }
}
