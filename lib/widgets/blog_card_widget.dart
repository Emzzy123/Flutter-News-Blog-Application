import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_blog/model/blog.dart';

//Arrays of colors for each blog post
final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.amber,
  Colors.pinkAccent,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
  Colors.black
];

class BlogCardWidget extends StatefulWidget {
  BlogCardWidget({
    Key? key,
    required this.blog,
    required this.index,
  }) : super(key: key);

  final Blog blog;
  final int index;

  @override
  _BlogCardWidgetState createState() => _BlogCardWidgetState();
}

class _BlogCardWidgetState extends State<BlogCardWidget> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    // Pick colors from the accent colors based on index
    final color = _lightColors[widget.index % _lightColors.length];
    final time = DateFormat.yMMMd().format(widget.blog.createdTime);
    final minHeight = getMinHeight(widget.index);

    //card widget
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 15,
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //datetime layout
            Text(
              'Date: ${DateFormat.yMMMd().format(widget.blog.createdTime)}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: buildPhoton(),
            ),
            // buildPhoton(),
            SizedBox(height: 10),
           //title layout
            Text(
              'Title: ${widget.blog.title}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            //description layout
            Text(
              'Description: \n${widget.blog.description}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 5,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoton(){
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null ? AssetImage("assets/images/whatisblog.png") : FileImage(File(_imageFile!.path)) as ImageProvider,
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }


  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 100;
      case 2:
        return 100;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}