import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    //print("blog is $blog");
    return Scaffold(
        appBar: AppBar(),
        
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Author: ${blog.posterName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${formatDateBydMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  style: const TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(blog.imageUrl),
                  ),
                const SizedBox(height: 20,),
                  Text(blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
