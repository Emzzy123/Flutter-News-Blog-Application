import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class BlogFormWidget extends StatefulWidget {
  //declaring Type value for fields
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final String? photon;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

//instantiation
  const BlogFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    this.photon = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,

  }) : super(key: key);

  @override
  _BlogFormWidgetState createState() => _BlogFormWidgetState();
}

//Display form field for title and body description
class _BlogFormWidgetState extends State<BlogFormWidget> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          buildTitle(),
          SizedBox(height: 20),
          buildDescription(),
          SizedBox(height: 20),
        ],
      ),
    ),
  );

//Textformfield method for text field
  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: widget.title,
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Please write your Title here ....',
      hintStyle: TextStyle(color: Colors.black),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: widget.onChangedTitle,
  );

  //Textformfield method for description field
  Widget buildDescription() => TextFormField(
    maxLines: 5,
    initialValue: widget.description,
    style: TextStyle(color: Colors.black, fontSize: 18),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Write your body here, Type something...',
      hintStyle: TextStyle(color: Colors.black),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: widget.onChangedDescription,
  );


}
