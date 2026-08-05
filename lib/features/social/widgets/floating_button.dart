import 'package:flutter/material.dart';

class FriendsFab extends StatelessWidget {

  final VoidCallback onCreateGroup;
  final VoidCallback onFindFriends;
  final VoidCallback onScanQR;

  const FriendsFab({
    super.key,
    required this.onCreateGroup,
    required this.onFindFriends,
    required this.onScanQR,
  });

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton<int>(

      offset: const Offset(0,-180),

      icon: Container(

        width:58,
        height:58,

        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      onSelected: (value){

        if(value==0) onCreateGroup();
        if(value==1) onFindFriends();
        if(value==2) onScanQR();

      },

      itemBuilder: (context)=>[

        const PopupMenuItem(
          value:0,
          child: ListTile(
            leading: Icon(Icons.groups),
            title: Text("Create Group"),
          ),
        ),

        const PopupMenuItem(
          value:1,
          child: ListTile(
            leading: Icon(Icons.person_add),
            title: Text("Find Friends"),
          ),
        ),

        const PopupMenuItem(
          value:2,
          child: ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text("Scan QR"),
          ),
        ),
      ],
    );
  }
}