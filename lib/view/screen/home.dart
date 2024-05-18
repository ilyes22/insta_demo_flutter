// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/repesetory/post.repesetory.dart';
import 'package:learn_bloc/view/screen/add.post.dart';
import 'package:learn_bloc/view/widget/post.grid.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    loading();
    super.initState();
  }

  void loading() {
    BlocProvider.of<PostBloc>(context).add(LoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post App'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider(
                      create: (context) => PostBloc(RepistoryServices()),
                      child: AddPost(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loading();
        },
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            // If a new post is added, reload the posts
            if (state is MessageSucses) {
              loading();
            }
          },
          builder: (context, state) {
            if (state is PostInitial) {
              return const Center(
                child: Text('Data are Loading..'),
              );
            } else if (state is LodingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoadedState) {
              return GridView.builder(
                  // scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 15),
                  itemCount: state.posts.length,
                  itemBuilder: (ctx, index) {
                    final post = state.posts[index];
                    return PostGrid(
                      post: post,
                    );
                  });
            } else if (state is MessageSucses) {
              BlocProvider.of<PostBloc>(context)
                  .add(LoadedEvent()); // Reload Post
              return Container(); // Or display a success message
            } else if (state is LoadedErroer) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
