import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10),
      color: c0C181F,
      child: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
            backgroundImage: const NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Elon Musk',
            style: TextStyle(
              color: cffffff,
              fontSize: 16,
            ),
          ),
          Spacer(),
          const Icon(
            Icons.search_rounded,
            color: cffffff,
          ),
          const SizedBox(
            width: 10,
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
