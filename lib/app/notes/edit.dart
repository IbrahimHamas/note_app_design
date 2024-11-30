import 'dart:io';

import 'package:appdesign/components/crud.dart';
import 'package:appdesign/components/customform.dart';
import 'package:appdesign/components/valid.dart';
import 'package:appdesign/constants/linkapi.dart';
import 'package:appdesign/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> with Crud {
  File? myfile;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;

  editNotes() async {
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var response;
      if (myfile == null) {
        response = await postRequest(linkEditNotes, {
          "title": title.text,
          "content": content.text,
          "id": widget.notes["notes_id"].toString(),
          "imagename": widget.notes["notes_image"].toString(),
        });
      } else {
        response = await postRequestWithFile(
            linkEditNotes,
            {
              "title": title.text,
              "content": content.text,
              "id": widget.notes["notes_id"].toString(),
              "imagename": widget.notes["notes_image"].toString(),
            },
            myfile!);
      }

      if (response['status'] == 'success') {
        Navigator.of(context).pushReplacementNamed("home");
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notes"),
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
                    ElevatedButton(
                        onPressed: () async {
                          await editNotes();
                        },
                        child: Text("Edit")),
                  ],
                ),
              )),
    );
  }
}
