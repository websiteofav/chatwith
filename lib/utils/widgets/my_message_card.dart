import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String time;
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
            elevation: 1,
            color: c604949,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20,
                    bottom: 20,
                    top: 5,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          color: cC3B9B9,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.done_all,
                        color: cC3B9B9,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
