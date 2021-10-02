import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/profile/profile_model.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  const PersonCard(
      {Key? key,
      required this.profile,
      this.selected = false,
      this.callback,
      this.elevation = 8})
      : super(key: key);

  final Profile profile;
  final bool selected;
  final double elevation;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: callback,
      child: PhysicalModel(
        color: !selected ? Colors.white : Colors.amber,
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (profile.avatar?.isNotEmpty ?? false)
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('${UserApi.userAvatar}${profile.avatar}'),
                )
              else
                const CircleAvatar(
                  backgroundImage: AssetImage('images/logo60.png'),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${profile.surname} ${profile.patronymic} ${profile.name}'),
                      Text(profile.profileStatusToString)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
