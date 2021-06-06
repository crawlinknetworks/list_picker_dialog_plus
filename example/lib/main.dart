import 'package:flutter/material.dart';
import 'package:list_picker_dialog_plus/list_picker_dialog_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Picker Demo'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            ElevatedButton(
              child: Text("Open List Picker"),
              onPressed: () async {
                var item = await showListPicker(
                    context: context,
                    selectedItem: _selectedItem,
                    findFn: (str) async => [
                          "Apple",
                          "Bannana",
                          "Grapes",
                          "Orrange",
                          "Pineapple",
                        ],
                        
                    filterFn: (dynamic item, str) =>
                        item.toLowerCase().indexOf(str.toLowerCase()) >= 0,
                    listItemFn: (item, position, focused, selected, onTap) =>
                        ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                                color: selected ? Colors.blue : Colors.black87),
                          ),
                          tileColor: focused
                              ? Color.fromARGB(10, 0, 0, 0)
                              : Colors.transparent,
                          onTap: onTap,
                        ));
                if (item != null) {
                  setState(() {
                    _selectedItem = item;
                  });
                }
              },
            ),
            SizedBox(
              height: 32,
            ),
            Text('Selected Item = $_selectedItem')
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
