import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendSearchPage extends HookConsumerWidget {
  const FriendSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useTextEditingController();
    final hasText = useState(false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "검색",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: hasText.value
                  ? Border.all(color: Colors.yellow, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 35,
                  margin: EdgeInsets.only(right: 5),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: searchText,
                    autofocus: true,
                    cursorWidth: 1.5,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      isDense: true,
                      hint: Text(
                        "친구의 닉네임 또는 초대코드를 입력하세요",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      hasText.value = value.isNotEmpty;
                    },
                  ),
                ),
                hasText.value
                    ? InkWell(
                        onTap: () {
                          searchText.clear();
                          hasText.value = false;
                        },
                        child: Container(
                          width: 35,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.cancel,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
