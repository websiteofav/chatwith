import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/images.dart';
import 'package:chatwith/features/chat/screens/chat_list.dart';
import 'package:chatwith/features/chat/screens/contacts_list.dart';
import 'package:chatwith/utils/widgets/profile_bar.dart';
import 'package:chatwith/utils/widgets/web_chat_appbar.dart';
import 'package:chatwith/utils/widgets/web_search_bar.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Scaffold with a text in center body of the screen
    return Scaffold(
        body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: const [
            ProfileBar(),
            WebSearchBar(),
            ContactsList(),
          ],
        ))),
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Images.backGroundImage), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              const WebChatAppBar(),
              const Expanded(
                  child: ChatList(
                receiverUserId: '',
              )),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: c131C21,
                    border: Border(bottom: BorderSide(color: cC3B9B9))),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_emotions_rounded,
                      color: c9FFFF06,
                    ),
                    const Icon(
                      Icons.attach_file_rounded,
                      color: c767272,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: c55554D,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 12,
                          ),
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.mic_rounded,
                      color: coC54BE,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
