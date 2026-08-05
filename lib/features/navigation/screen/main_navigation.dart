// import 'package:flutter/material.dart';
// import '../../home/screen/home_screen_costumer.dart';
// import '../../home/screen/home_screen_booth.dart';
// import '../../home/screen/home_screen_eo.dart';
// import '../../event/screen/event_screen.dart';
// import '../../../shared/widgets/navbar_booth.dart';

// enum UserRole {
//   customer,
//   booth,
//   eo,
// }

// class MainNavigationScreen extends StatefulWidget {
//   final UserRole role;

//   const MainNavigationScreen({
//     super.key,
//     required this.role,
//   });

//   @override
//   State<MainNavigationScreen> createState() =>
//       _MainNavigationScreenState();
// }

// class _MainNavigationScreenState
//     extends State<MainNavigationScreen> {
//   int currentIndex = 0;

//   List<Widget> get pages {
//     switch (widget.role) {
//       case UserRole.customer:
//         return [
//           const HomeScreenCostumer(),
//           const EventScreen(),
//           const Placeholder(),
//           const Placeholder(),
//         ];

//       case UserRole.booth:
//         return [
//           const HomeScreenBooth(),
//           const EventScreen(),
//           const Placeholder(),
//           const Placeholder(),
//         ];

//       case UserRole.eo:
//         return [
//           const HomeScreenEo(),
//           const EventScreen(),
//           const Placeholder(),
//           const Placeholder(),
//         ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: currentIndex,
//         children: pages,
//       ),

//       floatingActionButton:
//           widget.role == UserRole.customer
//               ? null
//               : FloatingActionButton(
//                   onPressed: () {
//                     if (widget.role == UserRole.booth) {
//                     } else {
//                     }
//                   },
//                   child: Icon(
//                     widget.role == UserRole.booth
//                         ? Icons.store
//                         : Icons.event,
//                   ),
//                 ),

//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.centerDocked,

//       bottomNavigationBar: NavBar(
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }