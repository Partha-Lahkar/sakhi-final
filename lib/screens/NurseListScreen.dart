import 'package:flutter/material.dart';
import 'package:sakhi/models/nurses.dart';
import 'package:sakhi/services/getnurses.dart';
import 'package:sakhi/screens/NurseDetailsScreen.dart';

class NurseListScreen extends StatefulWidget {
  @override
  _NurseListScreenState createState() => _NurseListScreenState();
}

class _NurseListScreenState extends State<NurseListScreen> {
  final NurseService nurseService = NurseService();
  List<Nurse> allNurses = [];

  @override
  void initState() {
    super.initState();
    fetchNurses();
  }

  void fetchNurses() {
    nurseService.getNurses().listen((List<Nurse> nurses) {
      setState(() {
        allNurses = nurses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse List'),
      ),
      body: allNurses.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: allNurses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NurseDetailsScreen(nurse: allNurses[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  allNurses[index].name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White font color
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  allNurses[index].phoneNumber,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70, // Lighter font color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(allNurses[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.blue, // Example background color
                  ),
                );
              },
            ),
    );
  }
}
