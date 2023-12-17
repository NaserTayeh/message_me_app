// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:messageme_app/common/utils/colors.dart';
// import 'package:messageme_app/screens/user_information_screen.dart';
// import 'package:uuid/uuid.dart';
// import '../models/group.dart' as model;

// class CreateGroupScreen extends StatefulWidget {
//   static const String routeName = '/create-group';
//   const CreateGroupScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateGroupScreen> createState() => _CreateGroupScreenState();
// }

// class _CreateGroupScreenState extends State<CreateGroupScreen> {
//   final TextEditingController groupNameController = TextEditingController();
//   File? image;

//   void selectImage() async {
//     image = await pickImageFromGallery(context);
//     setState(() {});
//   }

//   List<Contact> selectedGroupContacts = [];
//   void createGroups() {
//     if (groupNameController.text.trim().isNotEmpty && image != null) {
//       createGroup(
//         context,
//         groupNameController.text.trim(),
//         image!,
//         selectedGroupContacts,
//       );
//       // ref.read(selectedGroupContacts.state).update((state) => []);
//       Navigator.pop(context);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     groupNameController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Group'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Stack(
//               children: [
//                 image == null
//                     ? const CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
//                         ),
//                         radius: 64,
//                       )
//                     : CircleAvatar(
//                         backgroundImage: FileImage(
//                           image!,
//                         ),
//                         radius: 64,
//                       ),
//                 Positioned(
//                   bottom: -10,
//                   left: 80,
//                   child: IconButton(
//                     onPressed: selectImage,
//                     icon: const Icon(
//                       Icons.add_a_photo,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextField(
//                 controller: groupNameController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter Group Name',
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.all(8),
//               child: const Text(
//                 'Select Contacts',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const SelectContactsGroup(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: createGroups,
//         backgroundColor: tabColor,
//         child: const Icon(
//           Icons.done,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// void createGroup(BuildContext context, String name, File profilePic,
//     List<Contact> selectedContact) async {
//   try {
//     List<String> uids = [];
//     for (int i = 0; i < selectedContact.length; i++) {
//       var userCollection = await FirebaseFirestore.instance
//           .collection('users')
//           .where(
//             'phoneNumber',
//             isEqualTo: selectedContact[i].phones[0].number.replaceAll(
//                   ' ',
//                   '',
//                 ),
//           )
//           .get();

//       if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
//         uids.add(userCollection.docs[0].data()['uid']);
//       }
//     }
//     var groupId = const Uuid().v1();

//     String profileUrl = await storeFileToFirebase(
//       'group/$groupId',
//       profilePic,
//     );
//     model.Group group = model.Group(
//       senderId: FirebaseAuth.instance.currentUser!.uid,
//       name: name,
//       groupId: groupId,
//       lastMessage: '',
//       groupPic: profileUrl,
//       membersUid: [FirebaseAuth.instance.currentUser!.uid, ...uids],
//       timeSent: DateTime.now(),
//     );

//     await FirebaseFirestore.instance
//         .collection('groups')
//         .doc(groupId)
//         .set(group.toMap());
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
// }




// final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

// class SelectContactsGroup extends StatefulWidget {
//   const SelectContactsGroup({Key? key}) : super(key: key);

//   @override
//   State<ConsumerStatefulWidget> createState() =>
//       _SelectContactsGroupState();
// }

// class _SelectContactsGroupState extends State<SelectContactsGroup> {
//   List<int> selectedContactsIndex = [];

//   void selectContact(int index, Contact contact) {
//     if (selectedContactsIndex.contains(index)) {
//       selectedContactsIndex.removeAt(index);
//     } else {
//       selectedContactsIndex.add(index);
//     }
//     setState(() {});
//    read(selectedGroupContacts.state)
//         .update((state) => [...state, contact]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref.watch(getContactsProvider).when(
//           data: (contactList) => Expanded(
//             child: ListView.builder(
//                 itemCount: contactList.length,
//                 itemBuilder: (context, index) {
//                   final contact = contactList[index];
//                   return InkWell(
//                     onTap: () => selectContact(index, contact),
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: ListTile(
//                         title: Text(
//                           contact.displayName,
//                           style: const TextStyle(
//                             fontSize: 18,
//                           ),
//                         ),
//                         leading: selectedContactsIndex.contains(index)
//                             ? IconButton(
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.done),
//                               )
//                             : null,
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//           error: (err, trace) => ErrorScreen(
//             error: err.toString(),
//           ),
//           loading: () => const Loader(),
//         );
//   }
// }
