import 'dart:typed_data';
//table to store fields
final String tableBlogs = 'blogs';
//class model for creating database
class BlogFields {
  //value list to be READ
  static final List<String> values = [
    id, isImportant, number, title, description, time
  ];
  //field to store in database
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';

}

class Blog {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;


  const Blog({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,

  });
  //copy method of current blog object for modification
  Blog copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,

  }) =>
      Blog(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,

      );
  //convert json object to blog field object
  static Blog fromJson(Map<String, Object?> json) => Blog(
    id: json[BlogFields.id] as int?,
    isImportant: json[BlogFields.isImportant] == 1,
    number: json[BlogFields.number] as int,
    title: json[BlogFields.title] as String,
    description: json[BlogFields.description] as String,
    createdTime: DateTime.parse(json[BlogFields.time] as String),  //datetime object from json using parse

  );

  //Json format to map fields in the database
  Map<String, Object?> toJson() => {
    BlogFields.id: id,
    BlogFields.title: title,
    BlogFields.isImportant: isImportant ? 1 : 0, //mark field as important with 1 and 0 for not important
    BlogFields.number: number,
    BlogFields.description: description,
    BlogFields.time: createdTime.toIso8601String(), //convert datetime object to json format

  };
}


