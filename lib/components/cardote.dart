import 'package:appdesign/constants/linkapi.dart';
import 'package:appdesign/model/notemodel.dart';
import 'package:flutter/material.dart';

class CardNotes extends StatelessWidget {
  final void Function()? ontap;
  /*final String title;
  final String content;*/
  final NoteModel notemodel;
  final void Function()? onDelete;
  const CardNotes(
      {super.key,
      this.ontap,
      /* required this.title,
      required this.content,*/
      this.onDelete,
      required this.notemodel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ontap,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Image.network(
                    '$linkImageRoot/${notemodel.notesImage}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  )),
              Expanded(
                  flex: 2,
                  child: ListTile(
                    //  title: Text("$title"),
                    //  subtitle: Text("$content"),
                    title: Text("${notemodel.notesTitle}"),
                    subtitle: Text("${notemodel.notesContent}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                  )),
            ],
          ),
        ));
  }
}
