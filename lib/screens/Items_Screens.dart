import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:veg/model/category.dart';
import 'package:veg/model/datamodel.dart';
import 'package:veg/screens/ListPage.dart';
import 'package:http/http.dart' as http;

class ItemsScreens extends StatefulWidget {
  const ItemsScreens({super.key});

  @override
  State<ItemsScreens> createState() => _ItemsScreensState();
}

class _ItemsScreensState extends State<ItemsScreens> {
  @override
  void initState() {
    additemfrombackend();
    print("hello");
    super.initState();
  }

  List<GroceryItem> _grocieryitems = [];

  void additemfrombackend() async {
    final url = Uri.https("flutter-sample-cce1d-default-rtdb.firebaseio.com",
        "Hello_sample.json");
    final response = await http.get(url);

    final Map<String, dynamic> listitems = jsonDecode(response.body);
    final List<GroceryItem> _itemsgrociery = [];
    for (final list in listitems.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == list.value['category'])
          .value;

      _itemsgrociery.add(GroceryItem(
          id: list.key,
          name: list.value['name'],
          category: category,
          quantity: list.value['quantity']));
    }
    setState(() {
      _grocieryitems = _itemsgrociery;
    });
  }

  void _addicons() async {
    final newitem = await Navigator.push<GroceryItem>((context),
        MaterialPageRoute(builder: ((context) {
      return const ListPage();
    })));
    setState(() {
      _grocieryitems.add(newitem!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No notes"));
    if (_grocieryitems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _grocieryitems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(index),
              onDismissed: (direction) => setState(() {
                _grocieryitems.removeAt(index);
              }),
              child: ListTile(
                title: Text(_grocieryitems[index].name),
                trailing: Text(_grocieryitems[index].quantity.toString()),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _grocieryitems[index].category.color,
                ),
              ),
            );
          });
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("your grocery"),
          actions: [
            IconButton(onPressed: _addicons, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
