part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class LodingState extends PostState {}

final class LoadedState extends PostState {
  final List<Post> posts;

  LoadedState(this.posts);
}

final class AddPostState extends PostState {
  final Post post;
  AddPostState(this.post);
}

final class MessageSucses extends PostState {
  final String message;
  MessageSucses(this.message);
}

final class LoadedErroer extends PostState {
  final String error;
  LoadedErroer(this.error);
}
