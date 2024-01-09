import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:review_app/utils/methods.dart';

import '../../domain/entities/upload_review.dart';

class ReviewRepo {
  final _db = FirebaseFirestore.instance;
  static final reviewFireInstance = FirebaseFirestore.instance
                            .collection('posts');

  Future<bool> likeReview(int reviewId, bool isLiked) async {

    try {
      List<String>? details = await getLoginDetails();
      int userId = -1;

      if (details != null) {
        userId = int.parse(details[0]);
      }

      final snapshot = await _db.collection('reviews').doc(reviewId.toString());
      if(!isLiked){
        await snapshot.update({
        'likedBy': FieldValue.arrayUnion([
          userId
        ]),
      });
      } else if(isLiked){
        await snapshot.update({
        'likedBy': FieldValue.arrayRemove([
          userId
        ]),
      });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    final snapshot = await _db.collection('reviews').get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<bool> uploadReview(UploadReviewModel uploadReviewModel, File? imageSelected) async {

    try {
      final reference = _db.collection('posts');

      // Next Post Id
      String postId = reference.doc().id;

      List<String>? details = await getLoginDetails();
      int userId = -1;
      String username = '';
      final DateTime now = DateTime.now();
      String date = now.toString();

      if (details != null) {
        userId = int.parse(details[0]);
        username = details[1].toString();
      }

      // Upload Image
      String imageUrl = imageSelected == null ? 'null' : await _uploadFile(postId, imageSelected);

      print('${imageSelected == null} ### $imageUrl');

      uploadReviewModel.date = date;
      uploadReviewModel.mediaUrl = imageUrl;
      uploadReviewModel.postId = postId;
      uploadReviewModel.userId = userId;
      uploadReviewModel.username = username;

      final snapshot = reference.doc(postId);
      await snapshot.set(uploadReviewModel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _uploadFile(String postId, File mediaFile) async {
    try {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('post_medias');
      UploadTask uploadTask = storageRef.child(postId).putFile(mediaFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return 'null';
    }
  }
}
