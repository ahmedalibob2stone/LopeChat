

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../../common/enums/enum_massage.dart';
import 'DisplayTypeofMassage.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.prof,
  }) : super(key: key);

  final String message;
  final String date;
  final EnumData type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final EnumData repliedMessageType;
  final String prof;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SwipeTo(
      onLeftSwipe: (_) => onRightSwipe(),
      child:Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(prof),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey[400],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (repliedText.isNotEmpty) ...[
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DisplayTypeofMassage(
                              message: repliedText,
                              type: repliedMessageType,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        DisplayTypeofMassage(
                          message: message,
                          type: type,
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
