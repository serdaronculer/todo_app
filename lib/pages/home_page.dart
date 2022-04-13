import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/translation_helper.dart';
import 'package:todo_app/widgets/task_list_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../widgets/custom_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showAddTaskBottomSheet(),
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSearchTask();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var currentItem = _allTasks[index];
                return Dismissible(
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
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        const Text(
                          "remove_task",
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ],
                    ),
                  ),
                  onDismissed: (direction) =>
                      _removeTaskListAndDb(index, currentItem),
                  key: UniqueKey(),
                  child: TaskItem(task: currentItem),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ListTile(
              title: TextField(
                  style: TextStyle(fontSize: 20.sp),
                  decoration: InputDecoration(
                      hintText: "add_task".tr(), border: InputBorder.none),
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      Navigator.of(context).pop();
                      DatePicker.showTimePicker(context,
                          locale: TranslationHelper.getDeviceLanguage(context),
                          showSecondsColumn: false, onConfirm: (time) {
                        var task = Task.create(name: value, createdAt: time);

                        _addTaskListAndDb(task);
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  }),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getALLTask();
    setState(() {});
  }

  void _addTaskListAndDb(Task task) async {
    _allTasks.insert(0, task);
    await _localStorage.addTask(task: task);
    setState(() {});
  }

  _removeTaskListAndDb(int index, Task task) async {
    _allTasks.removeAt(index);
    _localStorage.deleteTask(task: task);
    setState(() {});
  }

  void _showSearchTask() async {
    await showSearch(
        context: context,
        delegate: CustomSearchDelegate(
            allTasks: _allTasks,
            deletedTask: (Task task) {
              int index =
                  _allTasks.indexWhere((element) => element.id == task.id);
              _removeTaskListAndDb(index, task);
            }));
    setState(() {});
  }
}
