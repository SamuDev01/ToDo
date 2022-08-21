import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/database_helper.dart';
import 'package:to_do/screens/taskpage.dart';
import 'package:to_do/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({ Key key }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Color(0xFFF6F6F6),
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Image(
                        width: 100,
                        image: AssetImage(
                          'assets/images/logo.png'
                        )
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                                      task: snapshot.data[index]
                                    )
                                    )).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data[index].title,
                                    desc: snapshot.data[index].description,
                                  ),
                                );
                              } 
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => TaskPage(task: null))
                      ).then((value) => setState(() {}));
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: [
                            Color(0xFF7349FE),
                            Color(0xFF643FDB)
                          ]
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      )
                    ),
                  ),
                )
              ],
            )
          ),
        ),
      );
  }
}