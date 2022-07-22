//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:tiktokclone/constants.dart';import 'package:tiktokclone/models/groupActivity.dart';
//
// class CreateGroupActivityController extends GetxController {
//
//   final Rx<List<GroupActivity>> _groupActivity = Rx<List<GroupActivity>>([]);
//
//   List<GroupActivity> get groupActivity => _groupActivity.value;
//
//   String _groupActivityId = "";
//
//   updatePostId(String id) {
//     _groupActivityId = id;
//     getGroupActivity();
//   }
//
//   getGroupActivity() async {
//     _groupActivity.bindStream(firestore.collection('videos').doc(_groupActivityId).collection(
//         'groupActivity').snapshots().map((QuerySnapshot query) {
//       List<GroupActivity> retValue = [];
//       for(var element  in query.docs){
//         retValue.add(GroupActivity.fromSnap(element));
//       }
//       return retValue;
//     }));
//   }
//
//   createGroup(String groupText) async {
//     try {
//       if (groupText.isNotEmpty) {
//         DocumentSnapshot userDoc = await firestore
//             .collection('groups')
//             .doc(authController.user.uid)
//             .get();
//
//
//         GroupActivity groupActivity = GroupActivity(
//             username: (userDoc.data()! as dynamic)['name'],
//             location: groupText.trim(),
//             datePublished: DateTime.now(),
//             friends: [],
//             uid: authController.user.uid,
//             id: 'Comment $len');
//         await firestore
//             .collection('videos')
//             .doc(_postId)
//             .collection('comments')
//             .doc('Comment $len')
//             .set(comment.toJson());
//         DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get();
//         await firestore.collection('videos').doc(_postId).update({
//           'commentCount' : (doc.data()! as dynamic)['commentCount']+1,
//         });
//       }
//
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
// }
