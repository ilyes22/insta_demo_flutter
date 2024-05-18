import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';

import 'package:learn_bloc/view/widget/post.grid.dart';

class Favorite extends ConsumerWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: const Text('Favorite'),
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is LoadedState) {
          final posts =
              state.posts.where((element) => element.isFavorite).toList();
          return posts.isEmpty
              ? const Center(
                  child: Text('list tis empty'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 15),
                  itemBuilder: (ctx, index) {
                    final post = posts[index];
                    return PostGrid(post: post);
                  },
                  itemCount: posts.length,
                );
        }
        return Container();
      }),
    );
  }
}
