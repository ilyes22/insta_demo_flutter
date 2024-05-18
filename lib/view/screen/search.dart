import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/model/post.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  List<Post> posts = [];
  List<Post> searchedPosts = [];
  List<Post> emptyPostsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: const Text('Search'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              buildSearchField(),
              const SizedBox(
                height: 10,
              ),
              buildListSearch()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        autocorrect: false,
        cursorColor: Colors.amber,
        controller: searchController,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          contentPadding: EdgeInsets.all(13),
          label: Text(
            'Post Name',
            style: TextStyle(color: Colors.black),
            maxLines: 1,
            selectionColor: Colors.amber,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          return search(value);
        },
      ),
    );
  }

  Widget buildListSearch() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is LoadedState) {
          posts = state.posts;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final post = searchController.text.isNotEmpty
                      ? searchedPosts[index]
                      : emptyPostsList[index];
                  return ListTile(
                    title: Text(post.name),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post.image),
                    ),
                  );
                },
                itemCount: searchController.text.isNotEmpty
                    ? searchedPosts.length
                    : emptyPostsList.length,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  void search(String searchedValue) {
    final searchedLists = posts
        .where((post) => post.name.toLowerCase().startsWith(searchedValue))
        .toList();

    setState(() {
      searchedPosts = searchedLists;
    });
  }
}
