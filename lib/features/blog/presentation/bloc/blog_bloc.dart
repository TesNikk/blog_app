import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/blog.dart';

part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
}) : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onFetchAllBlogs);
    on<FetchUserBlogs>(_onFetchUserBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
          posterId: event.posterId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }
  void _onFetchAllBlogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess( r)),
    );
  }
  void _onFetchUserBlogs(FetchUserBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading()); // Show loading state
    final res = await _getAllBlogs(NoParams()); // Fetch all blogs (modify if needed)
    res.fold(
          (l) => emit(BlogFailure(l.message)),
          (r) {
        final userBlogs = r.where((blog) => blog.posterId == event.userId).toList();
        emit(BlogDisplaySuccess(userBlogs));
      },
    );
  }

}
