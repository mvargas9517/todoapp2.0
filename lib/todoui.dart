import 'package:flutter/material.dart';
import 'package:todo/dbhelper.dart';

class Todoui extends StatefulWidget {
  @override
  _TodouiState createState() => _TodouiState();
}

class _TodouiState extends State<Todoui> {

  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = '';
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName : todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited = '';
    setState(() {
      validated = true;
      errtext = '';
    });
  }


// Card
  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          trailing: IconButton(
            onPressed: () {
            dbhelper.deletedata(row['id']);
            setState(() {
             
           });
            },
            icon: Icon(
              Icons.delete,
              )),
          title: Text(
            row['todo'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0
            ),
          ),
        ),
      ),
    ),);
     });
     return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Center(
          child: Text(
            'Add Task',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: texteditingcontroller,
              autofocus: true,
              onChanged: (_val) {
                todoedited = _val;
              },
              decoration: InputDecoration(
                errorText: validated ? null : errtext,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.purple,
                  onPressed: () {
                    if(texteditingcontroller.text.isEmpty) {
                      setState(() {
                        errtext = "Can't be Empty";
                        validated = false;
                      });
                    } else if (texteditingcontroller.text.length > 20) {
                      setState(() {
                        errtext = "Too many characters";
                      validated = false;
                      });
                    } else{
                      addtodo();
                    }
                  },
                  child: Text('ADD'),
                  )
              ],
            ),
          ],
        ),
      );
          },
        );
      }
      );
  }





  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if(snap.hasData == null) {
          return Center(
            child: Text(
              'No Data',
              ),
          );
        } else {
          if(myitems.length == 0){
            return Scaffold(
              floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: showalertdialog,
        child: Icon(Icons.add,
        color: Colors.white,),
      ),
      appBar: AppBar(
        title: Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'No Task Available'
          )),
            );
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: showalertdialog,
        child: Icon(Icons.add,
        color: Colors.white,),
      ),
      appBar: AppBar(
        title: Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
              child: Column(
              children: children,
          ),
      ),
      );
          }
        }
      },
      future: query(),
    );
  }
}
