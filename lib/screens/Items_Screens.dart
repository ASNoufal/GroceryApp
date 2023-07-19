import 'package:flutter/material.dart';
import 'package:veg/model/datamodel.dart';
import 'package:veg/model/dummy_items.dart';
import 'package:veg/screens/ListPage.dart';

class ItemsScreens extends StatefulWidget {
  const ItemsScreens({super.key});

  @override
  State<ItemsScreens> createState() => _ItemsScreensState();
}

class _ItemsScreensState extends State<ItemsScreens> {
  final List<GroceryItem> _grocieryitems = [];

  void _addicons() async {
    final newitems = await Navigator.push<GroceryItem>((context),
        MaterialPageRoute(builder: ((context) {
      return const ListPage();
    })));
    if (newitems == null) {
      return;
    }

    setState(() {
      _grocieryitems.add(newitems);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_grocieryitems.isEmpty) {
      content = const Center(child: Text("No notes"));
    } else {
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
