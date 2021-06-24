
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:news_blog/model/blog.dart';

class BlogsDatabase {
  static final BlogsDatabase instance = BlogsDatabase._init(); //global field that calls the constructor

  static Database? _database; //field that comes from the sqflite package

  BlogsDatabase._init(); //private constructor for the database

  Future<Database> get database async {  //connection to open the database
    if (_database != null) return _database!; //if statement to check if  database exist already

    _database = await _initDB('blog.db');  //initialized database if it does not exist
    return _database!;
  }

  //method to get file path
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath); //new path object

    return await openDatabase(path, version: 1, onCreate: _createDB); //open database
  }

  //create database for fields columns
  Future _createDB(Database db, int version) async {
    //types for each field
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableBlogs (        
  ${BlogFields.id} $idType, 
  ${BlogFields.isImportant} $boolType,
  ${BlogFields.number} $integerType,
  ${BlogFields.title} $textType,
  ${BlogFields.description} $textType,
  ${BlogFields.time} $textType,
  
  )
''');
  }
  //CRUD Operation - CREATE
  Future<Blog> create(Blog blog) async {
    final db = await instance.database;

    final id = await db.insert(tableBlogs, blog.toJson()); //convert blog object to JSON object
    return blog.copy(id: id); //copy method of id back to database
  }
  //CRUD Operation - READ blog post
  Future<Blog> readBlog(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBlogs,
      columns: BlogFields.values,
      where: '${BlogFields.id} = ?',
      whereArgs: [id], //prevent sql injection attacks
    );
    //check if map object is empty
    if (maps.isNotEmpty) {
      return Blog.fromJson(maps.first);  //convert map to json object
    } else {
      throw Exception('ID $id not found');
    }
  }
 //CRUD operation - READ multiple blog post
  Future<List<Blog>> readAllBlogs() async {
    final db = await instance.database;

    final orderBy = '${BlogFields.time} ASC';

    final result = await db.query(tableBlogs, orderBy: orderBy);

    return result.map((json) => Blog.fromJson(json)).toList();
  }
  //CRUD Operation - UPDATE blog post
  Future<int> update(Blog blog) async {
    final db = await instance.database;

    return db.update(
      tableBlogs,
      blog.toJson(),
      where: '${BlogFields.id} = ?',
      whereArgs: [blog.id],
    );
  }
  //CRUD Operation - DELETE blog post
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableBlogs,
      where: '${BlogFields.id} = ?',
      whereArgs: [id],
    );
  }

  //method to close database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}