import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/screens/description.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';

  @override
  void initState() {
    getuid();
    // TODO: implement initState
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!; //Returning the current user
    setState(() {
      uid = user.uid;
    });
  }

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var clearController = TextEditingController();

  // addTaskOfFirebase() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   final User user = await auth.currentUser!;
  //   String uid = user.uid;
  //   var time = DateTime.now();
  //   await FirebaseFirestore.instance
  //       .collection('tasks')
  //       .doc(uid)
  //       .collection('mytasks')
  //       .doc(time.toString())
  //       .set({
  //     'title': titleController.text,
  //     'description': descriptionController.text,
  //     'time': time.toString()
  //   });
  // }

  addTaskofFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time,
    });
    Fluttertoast.showToast(msg: 'Data added');
    titleController.text = '';
    descriptionController.text ='';
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Categories "),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Colors.purple[500],
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Write a title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a Description",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
                onPressed: () async {
                 await addTaskofFirebase();
                  Navigator.pop(context);
                },
                child: Text("Save"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout_sharp))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showFormDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
          backgroundColor: Colors.purple),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            // In the context of Firebase and Firestore, snapshots refers to a stream of
            // data that represents the current state of a collection or document in the database.
            // Whenever the data in the database changes, the stream emits a new snapshot of the data,
            // which can be processed by a StreamBuilder.
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final docs = snapshots.data?.docs;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var time = (docs![index]['timestamp'] as Timestamp).toDate();
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: (){Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                title: docs[index]['title'],
                                description: docs[index]['description'],
                              ),));},
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff563C5C),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // snapshots.data.docs.map(( DocumentSnapshot document){
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      docs![index]['title'],
                                      style: GoogleFonts.roboto(fontSize: 18),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(uid)
                                              .collection('mytasks')
                                              .doc(docs[index]['time'])
                                              .delete();
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      icon: Icon(Icons.delete_outline_rounded))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(DateFormat.yMd().add_jm().format(time)),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: docs?.length,
                );
              }
            }),
      ),
    );
  }
}
