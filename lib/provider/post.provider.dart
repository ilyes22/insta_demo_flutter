import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_bloc/data/model/post.dart';

class PostProvider extends StateNotifier<List<Post>> {
  PostProvider() : super([]);

  bool addPostFavorite(Post post) {
    final isFavorite = state.contains(post);

    if (isFavorite) {
      state =
          state.where((posts) => posts.isFavorite != post.isFavorite).toList();
      return false;
    } else {
      state = [post, ...state];
      return true;
    }
  }
}

final postProviderList =
    StateNotifierProvider<PostProvider, List<Post>>((ref) => PostProvider());
