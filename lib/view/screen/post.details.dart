// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
// import 'package:learn_bloc/data/model/post.dart';

// class PostDetails extends StatelessWidget {
//   PostDetails({super.key, required this.post});

//   final Post post;

//   bool isfev = false;

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.amber,
//             expandedHeight: MediaQuery.of(context).size.height * 0.75,
//             actions: [
//               IconButton(
//                   onPressed: () {
//                     BlocProvider.of<PostBloc>(context)
//                         .add(ToggleFavoriteEvent(post.id, !post.isFavorite));
//                   },
//                   icon: Icon(
//                     post.isFavorite ? Icons.favorite : Icons.favorite_outline,
//                     color: Colors.red,
//                   )),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               // expandedTitleScale: 5,

//               title: Text(
//                 post.name.toUpperCase(),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30),
//               ),
//               background: Image.network(
//                 post.image,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Text(
//                     post.content,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black54),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/model/post.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.amber,
            expandedHeight: MediaQuery.of(context).size.height * 0.75,
            actions: [
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  // Find the current post in the state
                  Post? currentPost;
                  if (state is LoadedState) {
                    currentPost = state.posts
                        .firstWhere((p) => p.id == post.id, orElse: () => post);
                  }

                  return IconButton(
                    onPressed: () {
                      if (currentPost != null) {
                        BlocProvider.of<PostBloc>(context).add(
                            ToggleFavoriteEvent(
                                currentPost.id, !currentPost.isFavorite));
                      }
                    },
                    icon: Icon(
                      currentPost?.isFavorite ?? post.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                post.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              background: Image.network(
                post.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    post.content,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
