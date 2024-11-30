import 'dart:io';

import 'package:appdesign/components/crud.dart';
import 'package:appdesign/components/customform.dart';
import 'package:appdesign/components/valid.dart';
import 'package:appdesign/constants/linkapi.dart';
import 'package:appdesign/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> with Crud {
  File? myfile;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;

  addNotes() async {
    if (myfile == null) {
      return AwesomeDialog(
          context: context, title: "هام", body: Text("الرجاء اضافة الصورة "))
        ..show();
    }
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var response = await postRequestWithFile(
          linkAddNotes,
          {
            "title": title.text,
            "content": content.text,
            "id": sharedPref.getString("id"),
          },
          myfile!);
      if (response['status'] == 'success') {
        Navigator.of(context).pushReplacementNamed("home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustomForm(
                        hint: "title",
                        mycontroller: title,
                        valid: (val) {
                          return validInput(val, 1, 40);
                        }),
                    CustomForm(
                        hint: "content",
                        mycontroller: content,
                        valid: (val) {
                          return validInput(val, 10, 100);
                        }),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            XFile? xfile = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              myfile = File(xfile!.path);
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Choose Image From Gallery",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            XFile? xfile = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.camera);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              myfile = File(xfile!.path);
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Choose Image From Camera",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: Text("Upload File")),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await addNotes();
                        },
                        child: Text("Add")),
                  ],
                ),
              )),
    );
  }
}
