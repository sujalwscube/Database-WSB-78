import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wsb_78_notes_app/Database/dbhelper.dart';
import 'package:wsb_78_notes_app/Models/notesmodel.dart';
import 'package:wsb_78_notes_app/widgets/uihelper.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  late DbHelper db;
  List<NotesModel>listnotes=[];
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();
  @override
  void initState() {
    super.initState();
    db=DbHelper.instance;
    getAllData();
  }

  getAllData()async{
    listnotes=await db.getData();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        centerTitle: true,
      ),
      body: ListView.builder(itemBuilder: (context,index){
        return ListTile(
          leading: Text("${listnotes[index].id}"),
          title: Text("${listnotes[index].title}"),
          subtitle: Text("${listnotes[index].desc}"),
        );
      },itemCount: listnotes.length,),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showBottomSheet();
      },child: Icon(Icons.add),),
    );
  }

  _showBottomSheet(){
     showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add Notes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
          UiHelper.CustomTextField(titleController,"Enter Title", Icons.title),
          UiHelper.CustomTextField(descController,"Enter Description", Icons.description),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              db.insertNote(NotesModel(title: titleController.text.toString(), desc: descController.text.toString()));
              log("Data Inserted");
              setState(() {
                getAllData();
              });
            }, child: Text("Add Notes"))
        ],),
      );
    },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)));
  }
}
