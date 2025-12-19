class UserProfiles {
  final String id;
  final String username;
  final String? avatarUrl;
  final DateTime birthdate;

  UserProfiles({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.birthdate,
  });

  int get age {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  factory UserProfiles.fromMap(Map<String, dynamic> map) {
    return UserProfiles(
      id: map['id'] as String,
      username: map['username'] as String,
      avatarUrl: map['avatar_url'] as String?,
      birthdate: DateTime.parse(map['birthdate']),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'username':username,
      'avatar_url':avatarUrl,
      'birthdate':birthdate.toIso8601String(),
    };
  }
}
