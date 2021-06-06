# list_picker_dialog_plus

List Dialog Picker with search and keyboard navigation.

## Getting Started
 
 ![](https://github.com/crawlinknetworks/list_picker_dialog_plus/blob/master/screenshots/screen1.png?raw=true)

## Install

##### pubspec.yaml
```
list_picker_dialog_plus: <version_number>
```

## Simple Text List Picker

```
var item = await showTextListPicker(
    context: context,
    selectedItem: _selectedItem,
    findFn: (str) async => [
    "Apple",
    "Bannana",
    "Grapes",
    "Orrange",
    "Pineapple",
    ],
);
if (item != null) {
    setState(() {
    _selectedItem = item;
    });
}
```


## Advance Option List Picker

```
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
```