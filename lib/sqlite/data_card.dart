import 'package:flutter/material.dart';

import 'data_model.dart';

class DataCard extends StatelessWidget {
  const DataCard(
      {Key? key, required this.data, required this.edit, required this.delete, required this.index})
      : super(key: key);
  final DataModel data;
  final Function edit;
  final Function delete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        selected: true,
        selectedTileColor: Colors.grey[300],
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue,
          child: IconButton(
              onPressed: () {
                edit(index);
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white54,
              )
          ),
        ),
        title: Text(data.property),
        subtitle: Text(data.price),
        onTap: (){
          // Navigator.of(context).pushNamed('/details');
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(data: data)));
        },
        trailing: CircleAvatar(
          backgroundColor: Colors.red,
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            onPressed: (){
              delete(index);
            },
          ),
        ),
      ),
    );
  }
  
}


class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({Key? key, required this.data}) : super(key: key);

  // Declare a field that holds the Todo.
  final DataModel data;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(data.reporter),
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Text(data.bedrooms),
      //
      //   ),
      // ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(data.property),
                    Text(data.bedrooms),
                    Text(data.price),
                    Text(data.furniture),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



