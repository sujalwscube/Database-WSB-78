import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsb_78_notes_app/Models/notesmodel.dart';

class DbHelper{
  DbHelper._();
  static final DbHelper instance=DbHelper._();
  Database? _database;
  static const note_table="notes";
  static const note_id="note_id";
  static const note_title="note_title";
  static const note_desc="note_desc";

  Future<Database>getDb()async{
    if(_database!=null){
      return _database!;
    }
    else{
      return await initDb();
    }
  }

  Future<Database>initDb()async{
    Directory directory=await getApplicationDocumentsDirectory();
    var dbpath=join(directory.path+"notesdb.db");
    return openDatabase(dbpath,version: 1,onCreate: (db,version){
      return db.execute("create table $note_table ( $note_id integer primary key autoincrement, $note_title text, $note_desc text ) ");
    });
  }

  insertNote(NotesModel notesModel)async{
    var db=await getDb();
    db.insert(note_table, notesModel.toMap());
  }
  Future<List<NotesModel>>getData()async{
    var db=await getDb();
    List<NotesModel>listNotes=[];
    var data=await db.query(note_table);
    for(Map<String,dynamic>eachdata in data){
      NotesModel notesModel=NotesModel.fromMap(eachdata);
      listNotes.add(notesModel);
    }
    return listNotes;
  }
}