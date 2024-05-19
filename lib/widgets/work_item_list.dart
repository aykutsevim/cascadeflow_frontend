import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping_list/models/work_item.dart';
import 'package:shopping_list/widgets/icons/task_icon.dart';

class WorkItemList extends StatefulWidget {
  const WorkItemList({super.key});

  @override
  State<WorkItemList> createState() => _WorkItemListState();
}

class _WorkItemListState extends State<WorkItemList> {
  List<WorkItem> _workItems = [];
  //List<WeatherItem> _weatherItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchWorkItems();
  }

  Future<void> fetchWorkItems() async {
    final url = Uri.https('localhost:3001', 'api/workitem');

    final response = await http.get(url);

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

      final List<dynamic> fetchedRawData = json.decode(response.body);
      final List<WorkItem> loadedItems = fetchedRawData.map((item) => WorkItem.fromJson(item)).toList();
      /*for (final item in listData) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          WeatherItem(
            id : item['id'],
            date: item['date'],
            temperatureC: item['temperatureC'],
            temperatureF: item['temperatureF'],
            summary: item['summary'],
          ),
        );
      }*/
      setState(() {
        _workItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_workItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _workItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            //_removeItem(_weatherItems[index]);
          },
          key: ValueKey(_workItems[index].id),
          child: ListTile(
            title: Text(
              _workItems[index].description ?? '',
            ),
            leading: TaskIcon(taskType : _workItems[index].workItemTypeRef),
            trailing: Text(
              _workItems[index].workItemStateName,
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
        title: const Text('Task List'),
        actions: [
          IconButton(
            onPressed: () => {}, //_addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}