class LoginApi {
  static const login = 'https://e-legion.newpage.xyz/api/v1/auth/';
}

class UserApi {
  static const fetchUser = 'https://e-legion.newpage.xyz/api/v1/user_info/';
  static const editProfile =
      'https://e-legion.newpage.xyz/api/v1/edit_user_info/';
  static const changeAvatar =
      'https://e-legion.newpage.xyz/api/v1/change_avatar/';

  static const userAvatar = 'https://e-legion.newpage.xyz/files/avatar/';
}

class TeamsApi {
  static const fetchTeamsList =
      'https://e-legion.newpage.xyz/api/v1/get_member_teams/';
  static const fetchTeamMembers =
      'https://e-legion.newpage.xyz/api/v1/get_team_members/';
  static const searchUsers = 'https://e-legion.newpage.xyz/api/v1/search_user/';
  static const createTeam = 'https://e-legion.newpage.xyz/api/v1/create_team/';
  static const addTeamMember =
      'https://e-legion.newpage.xyz/api/v1/add_team_member/';
}

class CalendarApi {
  static const fetchCalendar =
      'https://e-legion.newpage.xyz/api/v1/get_calendar/';
  static const addEvent = 'https://e-legion.newpage.xyz/api/v1/add_event/';
  static const fetchRedmineCalendar = 'https://e-legion.newpage.xyz/api/v1/show_all_redmine_tasks/';
}
