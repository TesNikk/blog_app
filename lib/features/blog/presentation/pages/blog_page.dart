import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../bloc/blog_bloc.dart';
import '../widgets/blog_card.dart';
import 'add_new_blog_page.dart';

class BlogPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (context) => const BlogPage());
  }

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogGetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blog App'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: Icon(CupertinoIcons.add_circled),
            )
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                showSnackBar(context, state.error);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              if (state is BlogDisplaySuccess) {
                return ListView.builder(
                    itemCount: state.blogs.length,
                    itemBuilder: (context, index) {
                      final blog = state.blogs[index];
                      return BlogCard(blog: blog, color: AppPallete.gradient1);
                    });
              }
              return const SizedBox();
            }
        )
    );
  }
}
