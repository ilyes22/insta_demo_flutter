part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class Loading extends PostEvent {}

class LoadedEvent extends PostEvent {}

class AddPostEvent extends PostEvent {
  final Post post;
  AddPostEvent(this.post);
}

class UpdatePostEvent extends PostEvent {
  final Post post;
  UpdatePostEvent(this.post);
}

class DeletePostEvent extends PostEvent {
  final String postId;
  DeletePostEvent(this.postId);
}

class ToggleFavoriteEvent extends PostEvent {
  final String postId;
  final bool isFavorite;
  ToggleFavoriteEvent(this.postId, this.isFavorite);
}
