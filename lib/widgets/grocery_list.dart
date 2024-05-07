import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/models/weather_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  //List<WeatherItem> _weatherItems = [];
  List<WeatherItem> _loadedItems = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadedItems = await _loadItems();
  }

  Future<List<WeatherItem>> _loadItems() async {
    final url = Uri.https('localhost:3001', 'WeatherForecast');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items. Please try again later.');
    }

    if (response.body == 'null') {
      return [];
    }

    final List<dynamic> listData = json.decode(response.body);
    final List<WeatherItem> loadedItems = [];
    for (final item in listData) {
      /*final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;*/
      loadedItems.add(
        WeatherItem(
          id : item['id'],
          date: item['date'],
          temperatureC: item['temperatureC'],
          temperatureF: item['temperatureF'],
          summary: item['summary'],
        ),
      );
    }
    return loadedItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<WeatherItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _weatherItems.add(newItem);
    });
  }

  void _removeItem(int index) async {
    setState(() {
      _loadedItems.removeAt(index);
    });
/*
    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com',
        'shopping-list/${item.date}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        _weatherItems.insert(index, item);
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No items added yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].date + snapshot.data![index].summary),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: Colors.blue,
                ),
                trailing: Text(
                  snapshot.data![index].temperatureC.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
