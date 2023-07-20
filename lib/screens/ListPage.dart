import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:veg/model/category.dart';
import 'package:veg/model/datamodel.dart';
import 'package:http/http.dart' as http;

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var _currentcatagory = categories[Categories.vegetables];
  String _textfieldvalue = '';
  int _Quantity = 1;
  final _formkey = GlobalKey<FormState>();

  void _buttonclicked() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Data Saved")));
      final url = Uri.https("flutter-sample-cce1d-default-rtdb.firebaseio.com",
          "Hello_sample.json");
      final response = await http.post(url,
          headers: {
            'Content-Type': "Application/json",
          },
          body: jsonEncode({
            'name': _textfieldvalue,
            'category': _currentcatagory!.title,
            'quantity': _Quantity
          }));
      print(response.body);
      final Map<String, dynamic> ide = jsonDecode(response.body);
      if (context.mounted) {
        return Navigator.of(context).pop(GroceryItem(
            id: ide['name'],
            name: _textfieldvalue,
            category: _currentcatagory!,
            quantity: _Quantity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of items"),
      ),
      body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text("Names")),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length >= 50) {
                      return "Error Message";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _textfieldvalue = newValue!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value) >= 50 ||
                              int.parse(value) <= 1) {
                            return "error";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: "1",
                        onSaved: (newValue) => _Quantity = int.parse(newValue!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _currentcatagory,
                          items: [
                            for (final catogory in categories.entries)
                              DropdownMenuItem(
                                  value: catogory.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        color: catogory.value.color,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(catogory.value.title)
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            _currentcatagory = value!;
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formkey.currentState!.reset();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Reset Completed")));
                        },
                        child: const Text("Reset")),
                    const SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                        onPressed: _buttonclicked, child: const Text("sumbit"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
