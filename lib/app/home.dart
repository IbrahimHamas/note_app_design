import 'package:appdesign/app/notes/edit.dart';
import 'package:appdesign/components/cardote.dart';
import 'package:appdesign/components/crud.dart';
import 'package:appdesign/constants/linkapi.dart';
import 'package:appdesign/main.dart';
import 'package:appdesign/model/notemodel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  getNotes() async {
    var response =
        await postRequest(linkViewNotes, {"id": sharedPref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              sharedPref.clear();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('addnotes');
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['status'] == 'fail') {
                    return Center(child: Text("لا يوجد ملاحظات"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data['data'].length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return CardNotes(
                        notemodel: NoteModel.fromJson(snapshot.data['data'][i]),
                        ontap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return EditNotes(notes: snapshot.data['data'][i]);
                          }));
                        },
                        onDelete: () async {
                          var response = await postRequest(linkDeleteNotes, {
                            "id":
                                snapshot.data['data'][i]['notes_id'].toString(),
                            "imagename": snapshot.data['data'][i]['notes_image']
                                .toString()
                          });
                          if (response['status'] == 'success') {
                            Navigator.of(context).pushReplacementNamed("home");
                          }
                        },
                      );
                    },
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return SizedBox(
                  child: Text("Loading ..."),
                ); // Add return statement for other cases
              },
            ),
          ],
        ),
      ),
    );
  }
}
