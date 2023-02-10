import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: c131C21, border: Border(bottom: BorderSide(color: cC3B9B9))),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: c55554D,
          prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search_rounded,
                size: 20,
              )),
          hintStyle: const TextStyle(
            fontSize: 12,
          ),
          hintText: 'Search or start a new chat',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
