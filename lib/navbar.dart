// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// import 'package:simi/berita.dart';
// import 'package:simi/dashboard.dart';
// import 'package:simi/dataPersonal.dart';
// import 'package:simi/dataPersonal2.dart';
// import 'package:simi/graduation.dart';
// import 'package:simi/infoBerangkat.dart';
// import 'package:simi/infoPekerjaan.dart';
// import 'package:simi/trainingSchadule.dart';
// import 'package:simi/upDokumen.dart';
// import 'package:simi/trainingSchadule.dart'; 

// class DashboardTes extends StatefulWidget {
//   const DashboardTes({super.key});

//   @override
//   State<DashboardTes> createState() => _DashboardTesState();
// }

// class _DashboardTesState extends State<DashboardTes> {
//   final navigationKey = GlobalKey<CurvedNavigationBarState>();
//   int index = 1;

//   final List<Widget> navBarScreens = [
//     InfoberangkatPage(), 
//     Dashboard(),         
//     TrainingSchedulePage(), 
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final items = <Widget>[
//       const Icon(Icons.flight_takeoff),
//       const Icon(Icons.home),
//       const Icon(Icons.calendar_today),
//     ];

//     return Container(
//       color: Colors.blue.shade800,
//       child: SafeArea(
//         top: false,
//         child: ClipRect(
//           child: Scaffold(
//             extendBody: true,
//             backgroundColor: Colors.white,
//             body: navBarScreens[index],
//             bottomNavigationBar: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.pink[100]!,
//                     const Color.fromARGB(255, 244, 229, 186),
//                   ],
//                 ),
//               ),
//               child: Theme(
//                 data: Theme.of(context).copyWith(
//                   iconTheme: const IconThemeData(color: Colors.white),
//                 ),
//                 child: CurvedNavigationBar(
//                   key: navigationKey,
//                   color: Colors.transparent,
//                   buttonBackgroundColor: Colors.transparent,
//                   backgroundColor: Colors.transparent,
//                   animationCurve: Curves.easeInOut,
//                   animationDuration: const Duration(milliseconds: 300),
//                   height: 60,
//                   index: index,
//                   items: items,
//                   onTap: (newIndex) {
//                     setState(() => index = newIndex);
//                   },
//                 ),
//               ),
//             ),
//             drawer: Drawer(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   const DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                     ),
//                     child: Text('Menu'),
//                   ),
//                   ListTile(
//                     title: const Text('Berita'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => PopularNewsPage()));
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Data Personal 1'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => PersonalDataPage()));
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Data Personal 2'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => PersonalData2Page()));
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Info Pekerjaan'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => JobInfoPage()));
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Graduation'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => Graduation()));
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Upload Dokumen'),
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => UploadDocumentsPage()));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
