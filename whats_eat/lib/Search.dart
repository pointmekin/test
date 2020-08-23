import 'package:flutter/material.dart';

import 'CategoriesView.dart';
import 'PriceView.dart';

class Search extends SearchDelegate {
  final List<dynamic> restaurantList;

  Search(this.restaurantList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? restaurantList
        : restaurantList
        .where((element) =>
    (element[0].toString().toLowerCase().contains(query)) ||
        element[1].toString().toLowerCase().contains(query) ||
        element[2].toString().toLowerCase().contains(query))
        .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index){
          return Container(
            //height: 130,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    SizedBox(height:10),
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
                              Text(suggestionList[index][0].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),


                              suggestionList[index][1] == "\$"
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.attach_money, size: 15,),
                                ],
                              ) : suggestionList[index][1] == "\$\$"
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.attach_money, size: 15,),
                                  Icon(Icons.attach_money, size: 15,),
                                ],
                              ) : suggestionList[index][1] == "priceExpensive"
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
                              suggestionList[index][1] == "\$" ? "\$"
                                  :suggestionList[index][1] == "\$\$" ? "\$\$"
                                  : suggestionList[index][1] == "\$\$\$" ? "\$\$\$" : "",

                            ),
                            onPressed: () {

                              String price =
                              suggestionList[index][1].toString();


                              //print(foodName);
                              Navigator.pushReplacement(
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
                            label: Text(suggestionList[index][2]),
                            onPressed: () {

                              String category =
                              suggestionList[index][2].toString();


                              //print(foodName);
                              Navigator.pushReplacement(
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

        });
  }
}
