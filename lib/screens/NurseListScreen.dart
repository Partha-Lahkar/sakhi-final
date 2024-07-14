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
  List<Nurse> filteredNurses = [];

  // State variables for filters
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? selectedGender;
  bool lgbtqSupported = false;

  // Lists to hold dropdown menu items
  List<String> countriesList = [
    'India',
    'UK',
    'USA',
    // Add more countries as needed
  ];

  Map<String, List<String>> statesMap = {
    'India': ['Maharashtra', 'Uttar Pradesh', 'Delhi'],
    'UK': ['England', 'Scotland', 'Wales'],
    'USA': ['California', 'New York', 'Texas'],
    // Add more states for each country
  };

  Map<String, List<String>> citiesMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi'],
    'Delhi': ['New Delhi'],
    'England': ['London', 'Manchester', 'Birmingham'],
    'Scotland': ['Edinburgh', 'Glasgow'],
    'Wales': ['Cardiff', 'Swansea'],
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
    'New York': ['New York City', 'Buffalo'],
    'Texas': ['Houston', 'Dallas', 'Austin'],
    // Add more cities for each state
  };

  @override
  void initState() {
    super.initState();
    fetchNurses();
  }

  void fetchNurses() {
    nurseService.getNurses().listen((List<Nurse> nurses) {
      setState(() {
        allNurses = nurses;
        filteredNurses = List.from(allNurses);
      });
    });
  }

  void filterNurses() {
    setState(() {
      filteredNurses = allNurses.where((nurse) {
        bool countryCheck = selectedCountry == null ||
            nurse.country.toLowerCase() == selectedCountry!.toLowerCase();
        bool stateCheck = selectedState == null ||
            nurse.state.toLowerCase() == selectedState!.toLowerCase();
        bool cityCheck = selectedCity == null ||
            nurse.city.toLowerCase() == selectedCity!.toLowerCase();
        bool genderCheck = selectedGender == null ||
            nurse.gender.toLowerCase() == selectedGender!.toLowerCase();
        bool lgbtqCheck = !lgbtqSupported || nurse.lgbtqSupported;

        return countryCheck &&
            stateCheck &&
            cityCheck &&
            genderCheck &&
            lgbtqCheck;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: filteredNurses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredNurses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NurseDetailsScreen(nurse: filteredNurses[index]),
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
                                  filteredNurses[index].name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filteredNurses[index].phoneNumber,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image:
                                        AssetImage(filteredNurses[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (filteredNurses[index].lgbtqSupported)
                                 if (filteredNurses[index].lgbtqSupported)
                                Container(
                                  margin: EdgeInsets.only(top: 45, left: 40),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'lib/assets/lgbt.png',
                                      width: 20, // Adjust size as needed
                                      height: 20, // Adjust size as needed
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: Colors.blue,
                  ),
                );
              },
            ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Filter Options',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      onChanged: (String? value) {
                        setModalState(() {
                          selectedCountry = value;
                          selectedState = null;
                          selectedCity = null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Country',
                        border: OutlineInputBorder(),
                      ),
                      items: countriesList
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
                          .toList(),
                      dropdownColor:
                          Colors.white, // Background color of dropdown
                      style: TextStyle(
                          color: Colors.black), // Text color in dropdown
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedState,
                      onChanged: (String? value) {
                        setModalState(() {
                          selectedState = value;
                          selectedCity = null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select State',
                        border: OutlineInputBorder(),
                      ),
                      items: selectedCountry != null &&
                              statesMap.containsKey(selectedCountry!)
                          ? statesMap[selectedCountry!]!.map((state) {
                              return DropdownMenuItem(
                                value: state,
                                child: Text(state),
                              );
                            }).toList()
                          : [],
                      dropdownColor:
                          Colors.white, // Background color of dropdown
                      style: TextStyle(
                          color: Colors.black), // Text color in dropdown
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      onChanged: (String? value) {
                        setModalState(() {
                          selectedCity = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select City',
                        border: OutlineInputBorder(),
                      ),
                      items: selectedState != null &&
                              citiesMap.containsKey(selectedState!)
                          ? citiesMap[selectedState!]!.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              );
                            }).toList()
                          : [],
                      dropdownColor:
                          Colors.white, // Background color of dropdown
                      style: TextStyle(
                          color: Colors.black), // Text color in dropdown
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (String? value) {
                        setModalState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female'].map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      dropdownColor:
                          Colors.white, // Background color of dropdown
                      style: TextStyle(
                          color: Colors.black), // Text color in dropdown
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('LGBTQ Support'),
                      value: lgbtqSupported,
                      onChanged: (bool value) {
                        setModalState(() {
                          lgbtqSupported = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setModalState(() {
                              selectedCountry = null;
                              selectedState = null;
                              selectedCity = null;
                              selectedGender = null;
                              lgbtqSupported = false;
                            });
                          },
                          child: Text('Clear Filters'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              filterNurses(); // Apply filters
                            });
                            Navigator.pop(context); // Close the modal sheet
                          },
                          child: Text('Apply Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
