// screens/people_list.dart

import 'package:flutter/material.dart';
import 'package:sakhi/models/people.dart';
import 'package:sakhi/providers/poeple_db.dart';
import 'package:sakhi/screens/person_details.dart';
import 'package:sakhi/screens/add_person.dart';
import 'dart:io';

class PeopleListPage extends StatefulWidget {
  @override
  _PeopleListPageState createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  late Future<List<Person>> _peopleListFuture;

  @override
  void initState() {
    super.initState();
    _peopleListFuture = _getPeopleList();
  }

  Future<List<Person>> _getPeopleList() async {
    return await PersonDatabaseHelper().getAllPersons();
  }

  void _deletePerson(int id) async {
    await PersonDatabaseHelper().deletePerson(id);
    setState(() {
      _peopleListFuture = _getPeopleList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPersonPage(),
                ),
              ).then((_) {
                setState(() {
                  _peopleListFuture = _getPeopleList();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: _peopleListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No people found.'));
          } else {
            List<Person> people = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: people.length,
              itemBuilder: (context, index) {
                Person person = people[index];
                return Stack(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonDetailsPage(person: person),
                          ),
                        );
                      },
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 24,),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32.0),
                              child: person.photoPath.isNotEmpty
                                  ? Image.file(
                                      File(person.photoPath),
                                      fit: BoxFit.scaleDown,
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  person.name,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  person.relationship,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      right: 0.0,
                      
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,size: 30,),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Person'),
                              content: Text('Are you sure you want to delete this person?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deletePerson(person.id!);
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
