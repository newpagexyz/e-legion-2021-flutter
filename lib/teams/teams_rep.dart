import 'dart:convert';

import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:elegionhack/profile/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Team {
  final String team;
  final int id;
  Team({required this.team, required this.id});
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(team: json['name'], id: int.parse(json['id']));
  }
  @override
  operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return (other as Team).id == id;
    }
  }

  @override
  int get hashCode => id;
}

class TeamsList {
  final List<Team> teams;
  TeamsList(this.teams, this.selectedTeam);
  final int selectedTeam;
  TeamsList.empty()
      : teams = const [],
        selectedTeam = 0;
}

class TeamsListStateNotifier extends StateNotifier<AsyncValue<TeamsList>> {
  TeamsListStateNotifier(this.ref) : super(const AsyncLoading()) {
    load();
  }

  final ProviderRefBase ref;

  void load() async {
    final client = ref.watch(httpClientRepository);
    final creds = ref.watch(authStateNotifierProvider);
    try {
      final response = await client.post(Uri.parse(TeamsApi.fetchTeamsList),
          body: {'token': creds.credentials!.token});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body.toString());
        final teamsList = <Team>[];
        for (var team in json['body']) {
          teamsList.add(Team.fromJson(team));
        }

        state = AsyncData(TeamsList(teamsList, 0));
      } else {
        state = AsyncError('Could not fetch data');
      }
    } catch (e) {
      state = AsyncError('Network error');
    }
  }
}

final teamsListProvider =
    StateNotifierProvider<TeamsListStateNotifier, AsyncValue<TeamsList>>(
        (ref) => TeamsListStateNotifier(ref));

class TeamInfo {
  final Team team;
  final List<Profile> members;
  TeamInfo({required this.team, required this.members});
}

final teamInfoProvider =
    FutureProvider.family<TeamInfo, Team>((ref, team) async {
  final client = ref.watch(httpClientRepository);
  final creds = ref.watch(authStateNotifierProvider);

  final response = await client.post(Uri.parse(TeamsApi.fetchTeamMembers),
      body: {'token': creds.credentials!.token, 'tid': team.id.toString()});

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body.toString());
    final body = json['body'];
    final members = <Profile>[];

    for (var user in body) {
      members.add(Profile.fromJson(user));
    }

    return TeamInfo(team: team, members: members);
  } else {
    return TeamInfo(team: team, members: const []);
  }
});

class CreateTeamState {
  List<Profile> profiles;
  List<int> selected;

  final searchController = TextEditingController();
  final nameController = TextEditingController();

  CreateTeamState(this.profiles, this.selected);
  CreateTeamState.empty()
      : profiles = const [],
        selected = [];

  void dispose() {
    searchController.dispose();
    nameController.dispose();
  }
}

class CreateTeamNotifier extends ValueNotifier<CreateTeamState> {
  CreateTeamNotifier(this.ref) : super(CreateTeamState.empty()) {
    load();
  }

  final ProviderRefBase ref;
  var _initialized = false;

  void toggle(int uid) {
    if (value.selected.contains(uid)) {
      value.selected.removeWhere((element) => element == uid);
      notifyListeners();
    } else {
      value.selected.add(uid);
      notifyListeners();
    }
  }

  void create() async {
    final client = ref.watch(httpClientRepository);
    final creds = ref.watch(authStateNotifierProvider);

    final createResponse = await client.post(Uri.parse(TeamsApi.createTeam),
        body: {
          'token': creds.credentials!.token,
          'name': value.nameController.text
        });
    final createResponseJson = jsonDecode(createResponse.body.toString());

    final newTeamId = createResponseJson['body'];

    for (var user in value.selected) {
      await client.post(Uri.parse(TeamsApi.addTeamMember), body: {
        'token': creds.credentials!.token,
        'tid': newTeamId.toString(),
        'uid': user.toString()
      });
    }
  }

  void load({String query = ''}) async {
    if (!_initialized) {
      value.searchController.addListener(() {
        load(query: value.searchController.text);
      });
      _initialized = true;
    }

    final client = ref.watch(httpClientRepository);
    final creds = ref.watch(authStateNotifierProvider);

    final response = await client.post(Uri.parse(TeamsApi.searchUsers),
        body: {'token': creds.credentials!.token, 'query': query});

    final entries = <Profile>[];
    final json = jsonDecode(response.body.toString());
    for (var user in json['body']) {
      entries.add(Profile.fromJson(user));
    }

    value.profiles = entries;
    notifyListeners();
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }
}

final createTeamProvider = ChangeNotifierProvider<CreateTeamNotifier>(
    (ref) => CreateTeamNotifier(ref));
