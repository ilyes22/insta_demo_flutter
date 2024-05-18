import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/model/post.dart';
import 'package:learn_bloc/view/screen/add.post.dart';
import 'package:learn_bloc/view/screen/post.details.dart';
// import 'package:learn_bloc/view/widget/img.dialog.dart';

class PostGrid extends ConsumerStatefulWidget {
  const PostGrid({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<PostGrid> createState() => _PostGridState();
}

class _PostGridState extends ConsumerState<PostGrid> {
  @override
  Widget build(BuildContext context) {
    return buildGridTileView(context, widget.post);
  }

  Widget buildGridTileView(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridTile(
        //Footer

        footer: Container(
          height: 60,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            title: Text(
              post.name.toUpperCase(),
              style: const TextStyle(color: Colors.amber),
            ),
            // trailing: IconButton(
            //   onPressed: () {
            //     // final favList = ref.watch(postProviderList);
            //     // final isFavorite = favList.contains(post);
            //     // if (isFavorite) {
            //     //   return;
            //     // // }
            //     // ref
            //     //     .read(postProviderList.notifier)
            //     //     .addPostFavorite(post);
            //   },
            //   icon: post.isFavorite
            //       ? const Icon(Icons.favorite)
            //       : const Icon(Icons.favorite_border),
            //   color: Colors.red,
            // ),
          ),
        ),

        //Headrer
        header: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 231, 230, 230),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: ListTile(
            trailing: PopupMenuButton(
              onSelected: (value) {
                // your logic
              },
              itemBuilder: (BuildContext bc) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => AddPost(
                            post: post,
                          ),
                        ),
                      );
                    },
                    child: const Text("Edit post"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      BlocProvider.of<PostBloc>(context)
                          .add(DeletePostEvent(post.id));
                      BlocProvider.of<PostBloc>(context).add(LoadedEvent());
                    },
                    child: const Text("Delete Post"),
                  ),
                ];
              },
            ),
            title: Text(
              post.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: Text(
                '1',
              ),
            ),
          ),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(20)),
          child: SafeArea(
            child: SizedBox(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => PostDetails(
                      post: post,
                    ),
                  );
                },
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/a.gif',
                  image: post.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
