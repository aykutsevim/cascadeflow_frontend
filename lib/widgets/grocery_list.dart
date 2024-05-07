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
  List<WeatherItem> _weatherItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('localhost:3001', 'WeatherForecast');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
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
      setState(() {
        _weatherItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
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

  void _removeItem(WeatherItem item) async {
    final index = _weatherItems.indexOf(item);
    setState(() {
      _weatherItems.remove(item);
    });
/*
    final url = Uri.https('flutter-prep-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

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
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_weatherItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _weatherItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_weatherItems[index]);
          },
          key: ValueKey(_weatherItems[index].id),
          child: ListTile(
            title: Text(_weatherItems[index].date),
            leading: Text(
              _weatherItems[index].summary,
            ),
            trailing: Text(
              _weatherItems[index].temperatureC.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
