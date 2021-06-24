import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_blog/db/blog_database.dart';
import 'package:news_blog/model/blog.dart';
import 'package:news_blog/page/edit_blog_page.dart';
import 'package:news_blog/page/blog_detail_page.dart';
import 'package:news_blog/widgets/blog_card_widget.dart';
import 'dart:io';


class BlogsPage extends StatefulWidget {

  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  late List<Blog> blogs;  //List of all blog
  bool isLoading = false;
  bool isSearching = false;  //searchbar to false
  List filteredBlog = [];

  @override
  void initState() {
    super.initState();
    refreshBlogs();
  }

  void _filterBlogs(value) {
    print(value);
  }

  @override
  void dispose() {
    BlogsDatabase.instance.close();

    super.dispose();
  }
//refresh method to setState
  Future refreshBlogs() async {
    setState(() => isLoading = true);

    this.blogs = await BlogsDatabase.instance.readAllBlogs();  //read all note from database

    setState(() => isLoading = false);
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: Icon(Icons.menu_book, color: Colors.white,),
      title: !isSearching
          ? Text(
        'Blogs Client',
        style: TextStyle(fontSize: 24,),
      )
          : TextField(
        onChanged: (value) {
          _filterBlogs(value);
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search Blog Here",
            hintStyle: TextStyle(color: Colors.white)),
      ),
      actions: [
        isSearching
            ? IconButton(
          icon: Icon(Icons.cancel), color: Colors.white,
          onPressed: () {
            setState(() {
              this.isSearching = false;
            });
          },
        )
            : IconButton(
          icon: Icon(Icons.search), color: Colors.white,
          onPressed: () {
            setState(() {
              this.isSearching = true;
            });
          },
        ),

        SizedBox(width: 20),
        IconButton(icon: Icon(Icons.exit_to_app), onPressed: ()=> exit(0), iconSize: 30, color: Colors.white),
        SizedBox(width: 12),
      ],
      elevation: 20,
    ),
    body: SafeArea(
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : blogs.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'No News Blog added yet!',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  )),
            ],
          );
        })
            : buildBlogs(),
      ),
    ),

    //float button icon to create new blog post to the database
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.pink,
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddEditBlogPage()),
        );
        refreshBlogs();
      },
    ),
  );


  //Staggering gridview to display my blog post to the main page
  Widget buildBlogs() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: blogs.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final blog = blogs[index];
      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlogDetailPage(blogId: blog.id!),
          ));
          refreshBlogs();
        },
        child: BlogCardWidget(blog: blog, index: index), //display all blog with blog card
      );
    },
  );
}