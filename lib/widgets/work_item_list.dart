import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping_list/models/work_item.dart';

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

    _loadItems();
  }

  @override
  void initState() {
    super.initState();
    fetchWorkItems();
  }

  Future<void> fetchWorkItems() async {
    final response = await http.get(Uri.parse('http://localhost:3001/api/workitem'));
    if (response.statusCode == 200) {
      setState(() {
        workItems = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to fetch work items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Item List'),
      ),
      body: ListView.builder(
        itemCount: workItems.length,
        itemBuilder: (context, index) {
          final workItem = workItems[index];
          return ListTile(
            title: Text(workItem['title']),
            subtitle: Text(workItem['description']),
            // Add more fields as needed
          );
        },
      ),
    );
  }
}