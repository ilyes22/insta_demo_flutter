import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_bloc/data/model/post.dart';

class RepistoryServices {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('post');

  Stream<List<Post>> getData() {
    return postCollection
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post(
          id: doc.id,
          content: data['content'],
          image: data['image'],
          name: data['name'],
          isFavorite: data['isFavorite'] ?? false,
        );
      }).toList();
    });
  }

  Future<void> addPost(Post post) async {
    await postCollection.doc().set({
      'name': post.name,
      'content': post.content,
      'image': post.image,
      'isFavorite': post.isFavorite,
      'time': Timestamp.now(),
      'user': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> editPost(Post post) async {
    await postCollection.doc(post.id).update({
      'name': post.name,
      'content': post.content,
      'image': post.image,
      'isFavorite': post.isFavorite,
    });
  }

  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }

  Future<void> toggleFavoriteStatus(String postId, bool isFavorite) async {
    await postCollection.doc(postId).update({
      'isFavorite': isFavorite,
    });
  }
}
