import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListPickerDialog<T> extends StatefulWidget {
  final InputDecoration? searchDecoration;
  final Widget? title;

  final bool Function(T item, String str)? filterFn;
  final Future<List<T>> Function(String str) findFn;
  final ListTile Function(
    T item,
    int position,
    bool focused,
    bool selected,
    Function() onTap,
  ) listItemFn;
  final T? selectedItem;

  ListPickerDialog({
    Key? key,
    required this.findFn,
    required this.listItemFn,
    this.selectedItem,
    this.filterFn,
    this.searchDecoration,
    this.title,
  }) : super(key: key);

  @override
  _ListPickerDialogState createState() => _ListPickerDialogState();
}

class _ListPickerDialogState extends State<ListPickerDialog> {
  ValueNotifier<List<dynamic>>? _itemsValueNotifier;
  Timer? _debounce;
  String? _lastSearchString;
  int _listItemFocusedPosition = 0;

  @override
  void initState() {
    super.initState();
    _itemsValueNotifier = ValueNotifier([]);
    _search("");
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: AlertDialog(
        title: widget.title ?? Container(),
        content: Container(
          width: 380,
          constraints: BoxConstraints(maxHeight: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FocusScope(
                onKey: (_, event) => _onKeyPressed(context, event),
                child: TextField(
                    cursorColor: Colors.black,
                    onChanged: (str) => _onChanged(str),
                    autofocus: true,
                    decoration: widget.searchDecoration ??
                        InputDecoration(
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(),
                            hintText: "Search...")),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _itemsValueNotifier!,
                  builder: (context, List<dynamic> items, _) =>
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, position) {
                            var item = items[position];
                            Function() onTap = () {
                              _listItemFocusedPosition = position;
                              _selectValue(context);
                              // Navigator.pop(context, item);
                            };
                            ListTile listTile = widget.listItemFn(
                              item,
                              position,
                              position == _listItemFocusedPosition,
                              item != null && widget.selectedItem == item,
                              onTap,
                            );
                            return listTile;
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onChanged(String str) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // print("_onChanged: $_lastSearchString = $str");
      if (_lastSearchString != str) {
        _lastSearchString = str;
        _search(str);
      }
    });
  }

  _search(String str) async {
    List<dynamic> items = await widget.findFn(str);

    if (str.isNotEmpty && widget.filterFn != null) {
      items = items.where((item) => widget.filterFn!(item, str)).toList();
    }

    _itemsValueNotifier!.value = items;
  }

  _selectValue(BuildContext context) {
    var item = _itemsValueNotifier!.value[_listItemFocusedPosition];
    Navigator.pop(context, item);
  }

  _onKeyPressed(BuildContext context, RawKeyEvent event) {
    // print('_onKeyPressed : ${event.character}');
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      _selectValue(context);
      return false;
    } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
      Navigator.pop(context);
      return true;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      int v = _listItemFocusedPosition;
      v++;
      if (v >= _itemsValueNotifier!.value.length) v = 0;
      _listItemFocusedPosition = v;
      _itemsValueNotifier!.value =
          List<dynamic>.from(_itemsValueNotifier!.value);
      return true;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      int v = _listItemFocusedPosition;
      v--;
      if (v < 0) v = _itemsValueNotifier!.value.length - 1;
      _listItemFocusedPosition = v;
      _itemsValueNotifier!.value =
          List<dynamic>.from(_itemsValueNotifier!.value);
      return true;
    }
    return false;
  }
}
