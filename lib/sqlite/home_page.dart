import 'package:flutter/material.dart';
import 'package:rentalz_app/sqlite/colors.dart';
import 'package:rentalz_app/sqlite/about_us.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rentalz_app/sqlite/data_card.dart';
import 'package:rentalz_app/sqlite/data_model.dart';
import 'package:rentalz_app/sqlite/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController propertyController = TextEditingController();
  TextEditingController bedroomsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController furnitureController = TextEditingController();
  TextEditingController reporterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<DataModel> datas = [];
  bool fetching = true;
  int currentIndex = 0;

  late DB db;
  late List<DataModel> _findItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    getData();
    _findItem = datas;
  }

  // getData() -> local function
  void getData() async {
    // getData() -> from database.dart
    datas = await db.getData();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _textEditingController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(2.5),
          ),
          child: Center(
            child: TextFormField(
              onChanged: (value) => onSearchTextChanged(value),
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Search'),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyDilogue();
        },
        child: Icon(Icons.add),
      ),
      body: fetching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _findItem.length,
              itemBuilder: (context, index) => DataCard(
                data: _findItem[index],
                edit: edit,
                index: index,
                delete: delete,
              ),
            ),
      drawer: Drawer(
        child: ListView(
          children:  <Widget>[
            DrawerHeader(
                child: Text(
              'RentalZ',
              style: TextStyle(color: Colors.black38, fontSize: 45),
            )),
            ListTile(
              title:  Text('About Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
              },
            )
          ],
        ),
      ),
    );
  }


  // Form to Create New Property
  void showMyDilogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              // height: 150,
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: propertyController,
                    decoration: InputDecoration(labelText: 'Property Type'),
                    validator: (val) =>
                        val!.isEmpty ? 'You must provide something!' : null,
                  ),
                  TextFormField(
                    controller: bedroomsController,
                    decoration: InputDecoration(labelText: 'Bedrooms'),
                    validator: (val) =>
                        val!.isEmpty ? 'You must provide something!' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    validator: (val) =>
                        val!.isEmpty ? 'You must provide something!' : null,
                  ),
                  TextFormField(
                    controller: furnitureController,
                    decoration: InputDecoration(labelText: 'Furniture Type'),
                    validator: (val) =>
                        val!.isEmpty ? 'You must provide something!' : null,
                  ),
                  TextFormField(
                    controller: reporterController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (val) =>
                        val!.isEmpty ? 'You must provide something!' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      DataModel dataLocal = DataModel(
                        property: propertyController.text,
                        bedrooms: bedroomsController.text,
                        price: priceController.text,
                        furniture: furnitureController.text,
                        reporter: reporterController.text,
                      );
                      db.insertData(dataLocal);
                      dataLocal.id = datas[datas.length - 1].id! + 1;
                      setState(() {
                        datas.add(dataLocal);
                      });
                      propertyController.clear();
                      bedroomsController.clear();
                      priceController.clear();
                      furnitureController.clear();
                      reporterController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  // Update Dilogue
  void showMyDilogueUpdate() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextFormField(
                    controller: propertyController,
                    decoration: InputDecoration(labelText: 'Property Type'),
                  ),
                  TextFormField(
                    controller: bedroomsController,
                    decoration: InputDecoration(labelText: 'Bedrooms'),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  TextFormField(
                    controller: furnitureController,
                    decoration: InputDecoration(labelText: 'Furniture Type'),
                  ),
                  TextFormField(
                    controller: reporterController,
                    decoration: InputDecoration(labelText: 'Name'),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DataModel newData = datas[currentIndex];
                    newData.property = propertyController.text;
                    newData.bedrooms = bedroomsController.text;
                    newData.price = priceController.text;
                    newData.furniture = furnitureController.text;
                    newData.reporter = reporterController.text;
                    db.update(newData, newData.id!);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }

  void onSearchTextChanged(String text) {
    List<DataModel> results = [];
    if (text.isEmpty) {
      results = datas;
    } else {
      results = datas
          .where((item) =>
              item.property.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    setState(() {
      _findItem = results;
    });
  }

  // Edit method
  void edit(index) {
    // Display the previous value -> Easier to edit
    currentIndex = index;
    propertyController.text = datas[index].property;
    bedroomsController.text = datas[index].bedrooms;
    priceController.text = datas[index].price;
    furnitureController.text = datas[index].furniture;
    reporterController.text = datas[index].reporter;
    showMyDilogueUpdate();
  }

  // Delete method
  void delete(int index) {
    db.delete(datas[index].id!);
    setState(() {
      datas.removeAt(index);
    });
  }
}

class AboutUs extends StatelessWidget {

  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RentalZ'),
      ),
      body: ListView(
        children: [
          CustomWidgets.socialButtonRect(
              'Login with Facebook', facebookColor, FontAwesomeIcons.facebookF,
              onTap: () {
                Fluttertoast.showToast(msg: 'I am facebook');
              }),
          CustomWidgets.socialButtonRect(
              'Login with Google', googleColor, FontAwesomeIcons.googlePlusG,
              onTap: () {
                Fluttertoast.showToast(msg: 'I am google');
              }),

          CustomWidgets.socialButtonRect(
              'Login with Github', githubColor, FontAwesomeIcons.github,
              onTap: () {
                Fluttertoast.showToast(msg: 'I am github');
              }),

        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.socialButtonCircle(
                  facebookColor, FontAwesomeIcons.facebookF,
                  iconColor: Colors.white, onTap: () {
                Fluttertoast.showToast(msg: 'I am circle facebook');
              }),
              CustomWidgets.socialButtonCircle(
                  googleColor, FontAwesomeIcons.googlePlusG,
                  iconColor: Colors.white, onTap: () {
                Fluttertoast.showToast(msg: 'I am circle google');
              }),
              CustomWidgets.socialButtonCircle(
                  whatsappColor, FontAwesomeIcons.whatsapp,
                  iconColor: Colors.white, onTap: () {
                Fluttertoast.showToast(msg: 'I am circle whatsapp');
              }),
            ],
          ),)
        ],
      )
    );
  }
}

