import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: cC3B9B9,
          ),
        ),
        color: c304450,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
            backgroundImage: const NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'),
          ),
          Spacer(),
          const Icon(
            Icons.comment_rounded,
            color: cffffff,
          ),
          SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.more_vert_rounded,
            color: cffffff,
          ),
        ],
      ),
    );
  }
}
