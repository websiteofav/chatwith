import 'package:chatwith/features/status/models/status_model.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/statusScreen';
  final Status status;
  const StatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final StoryController _storyController = StoryController();
  List<StoryItem> storyPageItems = [];

  @override
  void initState() {
    initializeStoryPageItems();
    super.initState();
  }

  void initializeStoryPageItems() {
    for (var i = 0; i < widget.status.imageUrls.length; i++) {
      storyPageItems.add(
        StoryItem.pageImage(
          url: widget.status.imageUrls[i],
          controller: _storyController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyPageItems.isEmpty
          ? const Loader()
          : StoryView(
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                }
              },
              storyItems: storyPageItems,
              controller: _storyController,
              inline: false,
              repeat: false,
              onComplete: () {
                Navigator.of(context).pop();
              },
            ),
    );
  }
}
