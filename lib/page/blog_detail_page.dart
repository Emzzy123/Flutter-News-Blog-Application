import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_blog/db/blog_database.dart';
import 'package:news_blog/model/blog.dart';
import 'package:news_blog/page/edit_blog_page.dart';
import 'package:share/share.dart';

class BlogDetailPage extends StatefulWidget {
  final int blogId;

  const BlogDetailPage({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  late Blog blog;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshBlog();
  }
  //Read method for database
  Future refreshBlog() async {
    setState(() => isLoading = true);
    this.blog = await BlogsDatabase.instance.readBlog(widget.blogId);
    setState(() => isLoading = false);
  }

  void share(BuildContext context, Blog blog){
    final String text = "Title: ${blog.title} \nDescription: ${blog.description}";
    Share.share(text);
  }

//Display the datetime object, title object and body description object to the Card widget --details page
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
        title: Text(
          'Blogs Client',
          style: TextStyle(fontSize: 24),
        ),
      actions: [editButton(), deleteButton(), shareButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            'Date: ${DateFormat.yMMMd().format(blog.createdTime)}',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 20),
          Text(
            'Title: \n${blog.title}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Description: \n${blog.description}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          )
        ],
      ),
    ),
  );


//Share button widget method to share the content of the blog
  Widget shareButton() => IconButton(
      icon: Icon(Icons.share, color: Colors.white,),
     onPressed: ()=>{
        share(context, blog),
     },
  );

//edit button widget method to update the blog post content
  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined, color: Colors.white,),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(   //navigate to new page for updating
          builder: (context) => AddEditBlogPage(blog: blog),
        ));
        refreshBlog();
      });

  //delete button widget method to delete the blog post content
  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete, color: Colors.white,),
    onPressed: () async {
      await BlogsDatabase.instance.delete(widget.blogId); //delete method from the database
      Navigator.of(context).pop();
    },
  );
}