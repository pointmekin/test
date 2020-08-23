import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:whats_eat/main.dart';


class NewFood extends StatefulWidget {
  @override
  _NewFoodState createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {

  String restaurantName;
  String price;
  String category;
  List<dynamic> newEntry = [];
  List<List<dynamic>> restaurantList = [];

  final _formKey = GlobalKey<FormState>();
  int _value = 1;


  ///////////////////////////
  // JSON Stuff
  File jsonFile;
  Directory dir;
  String fileName = "myFile.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  String defaultHeight;


  ////////////////////////////

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }


  void deleteFileContent() {
    this.setState(() {
      fileContent = null;
      jsonFile.writeAsStringSync(json.encode(fileContent));
      fileExists = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_formatCtrl.text = _format;
    //_dateTime = DateTime.parse(INIT_DATETIME);

    //Json information storing stuff
    //deleteFileContent();
    getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("New Food", style: TextStyle( color: Colors.black),),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(.7),
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: -15, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 10  horizontally
                        15.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ]
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Restaurant Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),

                    TextFormField(
                      validator: (value) => value.isEmpty ? 'Enter a restaurant name' : null,
                      //autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Restaurant Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          restaurantName = value;
                        });
                      },
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        print("saved");
                        setState(() {
                          restaurantName = value;
                        });
                      },

                    ),

                    SizedBox(height:20),

                    Row(
                      children: [
                        Text("Price", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ],

                    ),

                    SizedBox(height:5),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                price = "\$";
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width* 0.25,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: price == "\$" ? Colors.orangeAccent : Colors.grey.shade300.withOpacity(0.5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.attach_money),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                price = "\$\$";
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width* 0.25,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: price == "\$\$" ? Colors.orangeAccent : Colors.grey.shade300.withOpacity(0.5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.attach_money),
                                    Icon(Icons.attach_money),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width* 0.25,
                          height: 50,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                price = "\$\$\$";
                              });
                            },
                            child: Container(

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: price == "\$\$\$" ? Colors.orangeAccent : Colors.grey.shade300.withOpacity(0.5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.attach_money),
                                    Icon(Icons.attach_money),
                                    Icon(Icons.attach_money),
                                  ],
                                )
                            ),
                          ),
                        ),

                      ],
                    ),



                    SizedBox(height:15),

                    Row(
                      children: [
                        Text("Category", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),

                    TextFormField(
                      validator: (value) => value.isEmpty ? 'Enter a category' : null,
                      //autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Category',
                      ),
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        print("saved");
                        setState(() {
                          restaurantName = value;
                        });
                      },

                    ),
/*
                    Column(
                      children: [
                      ChoiceChip(
                      label: Text('Item'),
                      selected: _value == 1,
                      onSelected: (bool selected) {
                        setState(() {
                          _value = selected ? 1 : null;
                        });
                      })
                      ],
                    ),

 */
/*
                    Text(fileContent.toString()),
                    FlatButton.icon(
                      icon: Icon(Icons.edit), //`Icon` to display
                      label:
                      Text('Delete'), //`Text` to display
                      onPressed: () {
                        //Code to execute when Floating Action Button is clicked
                        print("deleted json file content");
                        deleteFileContent();
                      },
                    ),

 */


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {

            if (_formKey.currentState.validate() && price != null){

              Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());

              if(fileContent == null) {
                writeToFile("restaurantList", []);
              }

              newEntry = [restaurantName, price, category];
              fileContent['restaurantList'].add(newEntry);
              jsonFileContent['restaurantList'] = fileContent['restaurantList'];

              jsonFile.writeAsStringSync(json.encode(jsonFileContent));
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );

            }




          });
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ), // This trailing comm,
    );

  }
}
