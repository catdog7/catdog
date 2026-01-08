import 'package:flutter/material.dart';

class CommentUserWidget extends StatelessWidget {
  CommentUserWidget({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    final nickname = "콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이콩이";
    late String editedNickname;
    if (nickname.length > 16) {
      editedNickname = nickname.substring(0, 15) + "...";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/default_image.webp'),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 22,
                          child: Text(
                            editedNickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 22,
                          child: Text(
                            " 12월 5일",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFB3B3B3),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.only(right: 20),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(
                Icons.favorite_border,
                size: 20,
                color: Color(0xFFB3B3B3),
              ),
              const Text(
                "3",
                style: TextStyle(fontSize: 15, color: Color(0xFFB3B3B3)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
