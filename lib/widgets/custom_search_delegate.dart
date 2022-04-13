import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import 'task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;
  final Function(Task) deletedTask;

  CustomSearchDelegate({required this.allTasks, required this.deletedTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              onPressed: () {
                query.isEmpty ? null : query = "";
              },
              icon: const Icon(Icons.clear))
          : Container(),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
      iconSize: 18,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where((task) => task.name.toLowerCase().contains(query))
        .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(filteredList[index].id),
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(223, 4, 8, 65),
                  Color.fromRGBO(91, 1, 1, 50),
                ],
              ),
            ),
            child: Row(
              children:  [
               const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text("remove_task".tr(), style: const TextStyle(color: Colors.white))
              ],
            ),
          ),
          onDismissed: (direction) => deletedTask(filteredList[index]),
          child: TaskItem(
            task: filteredList[index],
          ),
        );
      },
      itemCount: filteredList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
