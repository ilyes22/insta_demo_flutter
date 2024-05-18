import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/model/post.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddPost extends StatefulWidget {
  AddPost({super.key, this.post});
  late Post? post;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? img;
  late TextEditingController nameController;
  late TextEditingController contentController;

  bool isPost = false;

  @override
  void initState() {
    if (widget.post != null) {
      nameController = TextEditingController(text: widget.post!.name);
      contentController = TextEditingController(text: widget.post!.content);

      img = File(widget.post!.image);
    } else {
      nameController = TextEditingController();
      contentController = TextEditingController();
    }

    img = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        title: widget.post != null
            ? const Text('edit Post')
            : const Text('Add Post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextFieldForPostTitle(nameController),
              buildTextFieldForPostTitle(contentController),
              const SizedBox(height: 10),
              if (widget.post != null) buildImageForEditingPlacement(),
              buildImageForPost(),
              const SizedBox(height: 20),
              buildButtonForAddPost(),
            ],
          ),
        ),
      ),
    );
  }

  void addImg() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      img = File(image.path);
    });
  }

  void addPost() async {
    setState(() {
      isPost = true;
    });
    final user = FirebaseAuth.instance.currentUser;

    final id = const Uuid().v4();

    if (widget.post != null) {
      final reference = FirebaseStorage.instance
          .ref('img')
          .child('update/${user!.uid}/$id.jpg');
      await reference.putFile(img!);
      final imageUrl = await reference.getDownloadURL();

      final updatedPost = widget.post!.copyWith(
        img: imageUrl,
        name: nameController.text,
        content: contentController.text,
      );
      if (mounted) {
        BlocProvider.of<PostBloc>(context).add(UpdatePostEvent(updatedPost));
        Navigator.pop(context);
      }
    } else {
      try {
        final reference =
            FirebaseStorage.instance.ref('post').child('${user!.uid}/$id.jpg');
        await reference.putFile(img!);
        final imageUrls = await reference.getDownloadURL();

        final post = Post(
          id: DateTime.now().toString(),
          content: contentController.text,
          image: imageUrls,
          name: nameController.text,
        );
        if (mounted) {
          BlocProvider.of<PostBloc>(context).add(AddPostEvent(post));
          BlocProvider.of<PostBloc>(context).add(LoadedEvent());

          Navigator.pop(context);
          setState(() {
            isPost = false;
          });
        }
      } catch (e) {
        setState(() {
          isPost = false;
        });
      }
    }
  }

  void updatePost() {}

//text Field
  Widget buildTextFieldForPostTitle(TextEditingController controller) {
    return TextField(
      autocorrect: false,
      maxLength: 50,
      style: TextStyle(color: Colors.amber),
      cursorColor: Colors.amber,
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          helperText: 'Add Title for your Post',
          label: Text(
            'Name',
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            selectionColor: Colors.amber,
          ),
          filled: true,
          fillColor: Colors.black),
    );
  }

//add Image
  Widget buildImageForPost() {
    return widget.post == null
        ? Container(
            clipBehavior: Clip.hardEdge,
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 191, 189, 189),
              borderRadius: BorderRadius.circular(20),
            ),
            child: img == null
                ? Center(
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.amber,
                      ),
                      onPressed: addImg,
                      label: const Text(
                        'Add Photo',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : Image.file(
                    img!,
                    fit: BoxFit.cover,
                  ))
        : Container();
  }

//edite Img
  Widget buildImageForEditingPlacement() {
    return Stack(
      children: [
        if (widget.post != null && img == null)
          Container(
              clipBehavior: Clip.hardEdge,
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                widget.post!.image,
                fit: BoxFit.cover,
              )),
        if (img != null)
          Container(
              clipBehavior: Clip.hardEdge,
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.file(
                img!,
                fit: BoxFit.cover,
              )),
        Positioned(
          right: 5,
          top: 5,
          child: TextButton(
            style: IconButton.styleFrom(
                backgroundColor: Colors.black54, foregroundColor: Colors.amber),
            onPressed: addImg,
            child: img != null
                ? const Text('Load new Photo')
                : const Text('Change Photo'),
          ),
        ),
      ],
    );
  }

//btn
  Widget buildButtonForAddPost() {
    return ElevatedButton(
        onPressed: addPost,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, foregroundColor: Colors.amber),
        child: isPost
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.post == null
                ? const Text('Add Post')
                : const Text('Update Post'));
  }
}
