import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';

import '../models/task_model.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  TaskItem({Key? key, required this.task}) : super(key: key);
  Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _textController = TextEditingController();
  // ignore: non_constant_identifier_names
  late LocalStorage _LocalStorage;
  @override
  void initState() {
    super.initState();
    _LocalStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color(0xffffffff),
          Color(0xffededed),
        ]),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        title: widget.task.isComplated
            ? Text(widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey))
            : TextField(
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: null,
                controller: _textController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) => setState(() {
                  if (value.isNotEmpty) {
                    widget.task.name = value;
                  } else {
                    widget.task.name = "Not specified";
                  }
                  _LocalStorage.updateTask(task: widget.task);
                }),
              ),
        leading: GestureDetector(
          onTap: () {
           
            _updateTaskAndDb();
          },
          child: Container(
            child: const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
                border: !widget.task.isComplated
                    ? Border.all(color: Colors.grey, width: 0.8)
                    : null,
                shape: BoxShape.circle,
                color: widget.task.isComplated ? Colors.green : Colors.white),
          ),
        ),
        trailing: Text(
          DateFormat("Hms").format(widget.task.createdAt),
        ),
      ),
    );
  }

  void _updateTaskAndDb() {
    widget.task.isComplated = !widget.task.isComplated;
    _LocalStorage.updateTask(task: widget.task);
    setState(() {});
  }
}
