import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:whats_eat/NewFood.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:whats_eat/PriceView.dart';

import 'CategoriesView.dart';
import 'Search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsEat',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'WhatsEat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool clickedRandomize = false;
  int randomizedNumber = 0;
  ///////////////////////////
  // JSON Stuff
  File jsonFile;
  Directory dir;
  String fileName = "myFile.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  ////////////////////////////

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists && fileContent != null) {
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








  void createNewEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewFood()),
    );
  }

  void randomizeFood() {

    int restaurantsListLength = fileContent['restaurantList'].length;
    Random random = new Random();
    int randomNumber = random.nextInt(restaurantsListLength);
    

    setState(() {
      randomizedNumber = randomNumber.round();
      print(randomizedNumber);
    });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    }).then((value) => (){
      setState(() {
        randomizeFood();
      });
    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("WhatsEat", style: TextStyle( color: Colors.black),),
        elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: Search(fileContent['restaurantList']));
          },)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height:20),



            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
                child: clickedRandomize && fileContent['restaurantList'].length > 0
                    ? Container(
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
                  padding: const EdgeInsets.symmetric(horizontal:20, vertical: 5),
                  child: Column(
                      children: [
                        SizedBox(height:10),
                        Row(
                          children: [
                            Text("Result", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Divider(),
                        //SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(

                              height: 40,
                              width: MediaQuery.of(context).size.width*0.8-20,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fileContent['restaurantList'][randomizedNumber][0].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),


                                  fileContent['restaurantList'][randomizedNumber][1] == "\$"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : fileContent['restaurantList'][randomizedNumber][1] == "\$\$"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : fileContent['restaurantList'][randomizedNumber][1] == "priceExpensive"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : Container()
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            ActionChip(

                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.monetization_on,),

                                ),
                                label: Text(
                                  fileContent['restaurantList'][randomizedNumber][1] == "\$" ? "\$"
                                      :fileContent['restaurantList'][randomizedNumber][1] == "\$\$" ? "\$\$"
                                      : fileContent['restaurantList'][randomizedNumber][1] == "priceExpensive" ? "\$\$\$" : "",

                                ),
                                onPressed: () {

                                  String price =
                                  fileContent['restaurantList'][randomizedNumber][1].toString();


                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PriceView(),
                                      settings: RouteSettings(
                                        arguments: price,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                            SizedBox(width:10),
                            ActionChip(

                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.list),

                                ),
                                label: Text(fileContent['restaurantList'][randomizedNumber][2]),
                                onPressed: () {

                                  String category =
                                  fileContent['restaurantList'][randomizedNumber][2].toString();


                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoriesView(),
                                      settings: RouteSettings(
                                        arguments: category,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                          ],
                        ),

                      ],
                  ),
                ),
                    )
                    : Container(
                      height: 140,
                      child: Center(
                        child: Text(
                        "Too indecisive to pick a place to eat? Tap the button to randomize a restaurant now!",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                      ),
                    )),

            SizedBox(height:20),



            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.orangeAccent,
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
              child: InkWell(

                onTap: (){
                  setState(() {
                    randomizeFood();
                    clickedRandomize = !clickedRandomize;
                  });

                },
                child: Center(
                  child: Container(

                    child: clickedRandomize ? Text("Nope", style: TextStyle(color: Colors.white, fontSize: 18),): Text("Randomize a Restaurant", style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                )

              ),
            ),
            SizedBox(height:20),

            Divider(),

            SizedBox(height:20),
            //fileContent == null ? Container() : Text(fileContent.toString()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Filter by Price", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10),
                        child: Row(
                          children: [
                            ActionChip(
                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.monetization_on,),
                                ),
                                label: Text("\$"
                                ),
                                onPressed: () {
                                  String price = "\$";
                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PriceView(),
                                      settings: RouteSettings(
                                        arguments: price,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                            SizedBox(width:10),
                            ActionChip(
                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.monetization_on,),
                                ),
                                label: Text("\$\$"
                                ),
                                onPressed: () {
                                  String price = "\$\$";
                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PriceView(),
                                      settings: RouteSettings(
                                        arguments: price,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                            SizedBox(width:10),
                            ActionChip(
                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.monetization_on,),
                                ),
                                label: Text("\$\$\$"
                                ),
                                onPressed: () {
                                  String price = "\$\$\$";
                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PriceView(),
                                      settings: RouteSettings(
                                        arguments: price,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height:20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("All Restaurants List", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),

                ],
              ),
            ),
            SizedBox(height: 10),



            fileContent== null || fileContent['restaurantList'].length == 0 ? Text("You have no list of restaurants yet.") : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            //controller: _controller,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: fileContent['restaurantList'].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:20, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow:[
                        BoxShadow(
                          color: Colors.grey.withOpacity(.7),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: -10, //extend the shadow
                          offset: Offset(
                            0.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20, vertical: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width*0.8-70,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fileContent['restaurantList'][index][0].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),


                                  fileContent['restaurantList'][index][1] == "\$"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : fileContent['restaurantList'][index][1] == "\$\$"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : fileContent['restaurantList'][index][1] == "\$\$\$"
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                      Icon(Icons.attach_money, size: 15,),
                                    ],
                                  ) : Container()


                                ],
                              ),


                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width*0.2,
                              child: Row(
                                children: [
                                  Container(
                                    width: 1,
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                  IconButton(
                                    onPressed: (){

                                      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());

                                      setState(() {
                                        fileContent['restaurantList'].removeAt(index);

                                        jsonFileContent['restaurantList'] = fileContent['restaurantList'];
                                        //jsonFileContent['restaurantList'] = fileContent['restaurantList'];
                                        jsonFile.writeAsStringSync(json.encode(jsonFileContent));

                                      });

                                      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            ActionChip(

                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.monetization_on,),

                                ),
                                label: Text(
                                    fileContent['restaurantList'][index][1] == "\$" ? "\$"
                                        :fileContent['restaurantList'][index][1] == "\$\$" ? "\$\$"
                                        : fileContent['restaurantList'][index][1] == "\$\$\$" ? "\$\$\$" : "",

                                ),
                                onPressed: () {

                                  String price =
                                  fileContent['restaurantList'][index][1].toString();


                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PriceView(),
                                      settings: RouteSettings(
                                        arguments: price,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                            SizedBox(width:10),
                            ActionChip(

                                avatar: CircleAvatar(
                                  //backgroundColor: Colors.grey.shade800,
                                  child: Icon(Icons.list),

                                ),
                                label: Text(fileContent['restaurantList'][index][2]),
                                onPressed: () {

                                  String category =
                                  fileContent['restaurantList'][index][2].toString();


                                  //print(foodName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoriesView(),
                                      settings: RouteSettings(
                                        arguments: category,
                                      ),
                                    ),
                                  );

                                  print("If you stand for nothing, Burr, what’ll you fall for?");
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            ),
            SizedBox(height:20)

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
              if(fileContent == null) {
                writeToFile("restaurantList", []);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewFood()),
              );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
