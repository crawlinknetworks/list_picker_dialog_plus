library list_picker_dialog_plus;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './src/list-picker-dialog.dart';

/// Shows a list picker with search capability
///
/// Parameters:
///
/// * [context] BuildContext [required]
/// * [findFn] Function to retun text list [required]
/// * [listItemFn] Generator function to create [ListTile]
/// * [filterFn] Filter function for search
/// * [searchDecoration] Search text filed decoration
/// * [title] Dialog title
/// * [selectedItem] Initial Selected Item
Future<T?> showListPicker<T>({
  required BuildContext context,
  required Future<List<T>> Function(String str) findFn,
  required ListTile Function(
    T item,
    int position,
    bool focused,
    bool selected,
    Function() onTap,
  )
      listItemFn,
  bool Function(T item, String str)? filterFn,
  InputDecoration? searchDecoration,
  Widget? title,
  T? selectedItem,
}) {
  return showDialog<T>(
      context: context,
      builder: (context) => ListPickerDialog(
            findFn: findFn,
            listItemFn: listItemFn,
            filterFn: filterFn,
            searchDecoration: searchDecoration,
            title: title,
            selectedItem: selectedItem,
          ));
}

/// Shows a simple text list picker with search capability
///
/// Parameters:
///
/// * [context] BuildContext [required]
/// * [findFn] Function to retun text list [required]
/// * [listItemFn] Generator function to create [ListTile]
/// * [filterFn] Filter function for search
/// * [searchDecoration] Search text filed decoration
/// * [title] Dialog title
/// * [selectedItem] Initial Selected Item
Future<String?> showTextListPicker({
  required BuildContext context,
  required Future<List<String>> Function(String str) findFn,
  ListTile Function(
    String item,
    int position,
    bool focused,
    bool selected,
    Function() onTap,
  )?
      listItemFn,
  bool Function(String item, String str)? filterFn,
  InputDecoration? searchDecoration,
  Widget? title,
  String? selectedItem,
}) {
  return showDialog<String>(
      context: context,
      builder: (context) => ListPickerDialog(
            findFn: findFn,
            filterFn: filterFn ??
                (dynamic item, str) =>
                    item.toLowerCase().indexOf(str.toLowerCase()) >= 0,
            listItemFn: (dynamic item, position, focused, selected, onTap) =>
                ListTile(
              title: Text(
                item,
                style:
                    TextStyle(color: selected ? Colors.blue : Colors.black87),
              ),
              tileColor:
                  focused ? Color.fromARGB(10, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
            searchDecoration: searchDecoration,
            title: title,
            selectedItem: selectedItem,
          ));
}
