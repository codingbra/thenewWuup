import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktokclone/models/video.dart';

import '../constants.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').orderBy("likes", descending:true ).snapshots().map((QuerySnapshot query) {
          List<Video> retValue = [];
          for (var element in query.docs) {
            retValue.add(Video.fromSnap(element));
          }
          return retValue;
        }));
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
      'likes' : FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}