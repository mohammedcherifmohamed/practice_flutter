import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Db {

  static Database? _database ;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath() , "app.db");

    return await openDatabase(
      path,
    version:1,
    onCreate: onCreate,
    );
  }
  Future<void> onCreate(Database db , int version) async{
    await db.execute('''
    create Table users (
        id integer primary key autoincrement ,
      name text ,
      email text 

    )''');
  }

  Future<List<Map<String,dynamic>>> getUsers() async{
    final db = await database ;
    List <Map<String,dynamic>> users = await db.rawQuery("select * from users");
    return users ;
  }

  Future<void> addUser(String name , String email ) async {
    print("inserting : "+ name + " " + email);
    final db = await database ;
    db.rawInsert("insert into users (name,email) values(?,?) ",[name,email]);
    print('success');

  }

  Future<void> destroy(String name) async{
    final db = await database ;
    print("deletein "+name+" ...");
    db.rawDelete("delete from users where name = ? ",[name],);

  }

}