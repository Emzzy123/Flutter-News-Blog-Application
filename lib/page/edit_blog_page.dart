import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_blog/db/blog_database.dart';
import 'package:news_blog/model/blog.dart';
import 'package:news_blog/widgets/blog_form_widget.dart';
import 'dart:async';

class AddEditBlogPage extends StatefulWidget {
  final Blog? blog;

  const AddEditBlogPage({
    Key? key,
    this.blog,
  }) : super(key: key);
  @override
  _AddEditBlogPageState createState() => _AddEditBlogPageState();
}

class _AddEditBlogPageState extends State<AddEditBlogPage> {

//form key state for formfield
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;


  @override
  void initState() {
    super.initState();

    isImportant = widget.blog?.isImportant ?? false;
    number = widget.blog?.number ?? 0;
    title = widget.blog?.title ?? '';
    description = widget.blog?.description ?? '';

  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        'Blogs Client',
        style: TextStyle(fontSize: 24),
      ),
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: BlogFormWidget(
        isImportant: isImportant,
        number: number,
        // photon: photon,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        // onChangedPhoton: (photon) => setState(() => this.photon = photon),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  //button widget method to save files on add or update to the database
  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateBlog,
        child: Text('Save'),
      ),
    );
  }

  //Add or update method for blog post
  void addOrUpdateBlog() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.blog != null;  //check if blog already existing before updating

      if (isUpdating) {
        await updateBlog();
      } else {
        await addBlog();
      }

      Navigator.of(context).pop();
    }
  }
//method to update blog object
  Future updateBlog() async {
    final blog = widget.blog!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await BlogsDatabase.instance.update(blog);  //call method on blog database class to update
  }

  //method to add blog object
  Future addBlog() async {
    final blog = Blog(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await BlogsDatabase.instance.create(blog); //call method on blog database class to create
  }

}