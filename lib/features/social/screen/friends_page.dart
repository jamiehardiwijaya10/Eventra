import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../widgets/header.dart';
import '../widgets/friends_search.dart';
import '../widgets/tab_bar.dart';
import '../widgets/group_card.dart';
import '../widgets/group_section.dart';
import '../widgets/friend_card.dart';
import '../widgets/friend_section.dart';
import '../widgets/request_card.dart';
import '../widgets/request_section.dart';
import '../widgets/suggested_card.dart';
import '../widgets/suggested_section.dart';
import '../widgets/floating_button.dart';
import '../widgets/empty_state.dart';

class FriendsChatPage extends StatefulWidget {
  const FriendsChatPage({
    super.key,
  });

  @override
  State<FriendsChatPage> createState() => _FriendsChatPageState();
}

class _FriendsChatPageState extends State<FriendsChatPage> {

  int selectedTab = 0;

  final searchController = TextEditingController();


  final currentGroup = const GroupChat(
    image: "assets/images/konser.png",
    title: "Fleet Snowfluff Concert",
    members: 15234,
    lastMessage: "Organizer: Concert starts in 20 minutes 🎉",
    time: "Now",
    unread: 8,
  );


  final otherGroups = const [

    GroupChat(
      image: "assets/images/konser.png",
      title: "Bandung Food Festival",
      members: 4820,
      lastMessage: "See you tomorrow!",
      time: "09:12",
      unread: 2,
    ),

    GroupChat(
      image: "assets/images/konser.png",
      title: "Coffee Expo",
      members: 2134,
      lastMessage: "Booth B12 has discount!",
      time: "Yesterday",
    ),

  ];


  final friends = const [

    FriendModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Kevin",
      online: true,
      subtitle: "Met at Fleet Snowfluff",
      lastMessage: "Let's meet near Gate 3!",
      time: "09:30",
      unread: 2,
    ),

    FriendModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Sarah",
      online: false,
      subtitle: "Bandung Food Festival",
      lastMessage: "Thank you!",
      time: "Yesterday",
    ),

  ];


  final requests = const [

    FriendRequestModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Jonathan",
      subtitle: "You attended Anime Expo together",
    ),

    FriendRequestModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Michelle",
      subtitle: "You visited Booth A12",
    ),

  ];


  final suggested = const [

    SuggestedFriendModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Andreas",
      subtitle: "Visited the same event",
    ),

    SuggestedFriendModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Felix",
      subtitle: "Mutual friend",
    ),

    SuggestedFriendModel(
      image: "assets/images/Remielle Dan.jpg",
      name: "Jessica",
      subtitle: "Bandung Culinary Festival",
    ),

  ];


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColor.white,


      bottomNavigationBar: const NavBar(
        currentIndex: 2,
      ),


      floatingActionButton: FriendsFab(
        onCreateGroup: () {
          print("create group");
        },

        onFindFriends: () {
          print("find friends");
        },

        onScanQR: () {
          print("scan qr");
        },
      ),


      body: SafeArea(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [

            Padding(

              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),


              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [

                  const FriendsChatHeader(),

                  const SizedBox(height:24),

                  FriendsSearch(
                    controller: searchController,
                  ),

                  const SizedBox(height:24),

                  ChatTabBar(
                    currentIndex: selectedTab,
                    onChanged: (index){
                      setState(() {
                        selectedTab = index;
                      });
                    },
                  ),
                  const SizedBox(height:20),
                ],
              ),
            ),



            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal:20,
                ),
                child: AnimatedSwitcher(
                  duration:
                  const Duration(milliseconds:250),
                  child: SingleChildScrollView(
                    key: ValueKey(selectedTab),
                    physics:
                    const BouncingScrollPhysics(),
                    padding:
                    const EdgeInsets.only(
                      bottom:100,
                    ),
                    child: selectedTab == 0 ? GroupSection(
                      currentGroup:
                      currentGroup,
                      otherGroups:
                      otherGroups,
                    ) : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        FriendRequestSection(
                          requests: requests,
                        ),

                        const SizedBox(height:28,),

                        friends.isEmpty ? EmptyState(
                          icon:
                          Icons.people_outline,
                          title:
                          "No Friends Yet",
                          subtitle:
                          "Join events and start connecting with people around you.",
                          buttonText:
                          "Find Friends",
                          onPressed: () {},
                        )
                            : FriendSection(
                          friends:
                          friends,
                        ),

                        SuggestedFriendSection(
                          friends: suggested,
                        ),

                        const SizedBox(
                          height:28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}