import 'package:bloc/bloc.dart';
import 'package:learn_bloc/data/model/post.dart';
import 'package:learn_bloc/data/repesetory/post.repesetory.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final RepistoryServices repistoryServices;
  PostBloc(this.repistoryServices) : super(PostInitial()) {
    on<LoadedEvent>((event, emit) async {
      try {
        emit(LodingState());
        final posts = await repistoryServices.getData().first;
        emit(LoadedState(posts));
      } catch (e) {
        emit(LoadedErroer(e.toString()));
      }
    });

    on<AddPostEvent>((event, emit) async {
      try {
        emit(LodingState());
        await repistoryServices.addPost(event.post);
        emit(MessageSucses('added Post suuccess'));
      } catch (e) {
        emit(LoadedErroer(e.toString()));
      }
    });

    on<UpdatePostEvent>((event, emit) async {
      try {
        emit(LodingState());
        await repistoryServices.editPost(event.post);
        final posts = await repistoryServices.getData().first;
        emit(LoadedState(posts));
      } catch (e) {
        emit(LoadedErroer(e.toString()));
      }
    });

    on<DeletePostEvent>((event, emit) async {
      try {
        emit(LodingState());
        await repistoryServices.deletePost(event.postId);
        final posts = await repistoryServices.getData().first;
        emit(LoadedState(posts));
      } catch (e) {
        emit(LoadedErroer(e.toString()));
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      try {
        emit(LodingState());
        await repistoryServices.toggleFavoriteStatus(
            event.postId, event.isFavorite);
        final posts = await repistoryServices.getData().first;
        emit(LoadedState(posts));
      } catch (e) {
        emit(LoadedErroer(e.toString()));
      }
    });
  }
}
