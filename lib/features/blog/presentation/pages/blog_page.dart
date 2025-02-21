import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_new_blog_page.dart';

class BlogPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (context) => const BlogPage());
  }
  const BlogPage({super.key});

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
    );
  }
}
