import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade300,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          bodyText1: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          headline6: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          subtitle1: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          subtitle2: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          caption: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          button: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
          overline: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ),
      home: YourExistingWidget(),
    );
  }
}

class YourExistingWidget extends StatefulWidget {
  @override
  _YourExistingWidgetState createState() => _YourExistingWidgetState();
}

class _YourExistingWidgetState extends State<YourExistingWidget> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  late SharedPreferences prefs;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Text(getTasksCount().toString()), // Update this part as needed
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.edit, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          searchController.clear();
                          _filterTasks();
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) {
                      _filterTasks();
                    },
                  ),
                ),
                tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.list,
                              size: 100.0,
                              color: Colors.grey,
                            ),
                            Text(
                              'List is empty',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(filteredTasks[index].title),
                            onDismissed: (direction) {
                              deleteTask(filteredTasks[index]);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey.shade300,
                                      Colors.grey.shade100
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  leading: Checkbox(
                                    value: filteredTasks[index].isCompleted,
                                    onChanged: (value) {
                                      setState(() {
                                        filteredTasks[index].isCompleted =
                                            value ?? false;
                                        _saveTasks();
                                      });
                                    },
                                  ),
                                  title: Text(
                                    filteredTasks[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: filteredTasks[index].isCompleted
                                          ? Colors.grey.shade500
                                          : Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredTasks[index].description,
                                        style: TextStyle(
                                          color:
                                              filteredTasks[index].isCompleted
                                                  ? Colors.grey.shade300
                                                  : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color:
                                                filteredTasks[index].isCompleted
                                                    ? Colors.grey.shade500
                                                    : Colors.black,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            _formatDate(
                                                filteredTasks[index].date),
                                            style: TextStyle(
                                              color: filteredTasks[index]
                                                      .isCompleted
                                                  ? Colors.grey.shade500
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width:
            1.5 * 56.0, // Assuming the standard size of a FloatingActionButton
        height: 1.5 * 56.0,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddTaskAlertDialog(
                  onTaskAdded: (task) {
                    setState(() {
                      tasks.add(task);
                      _saveTasks();
                      _filterTasks();
                    });
                  },
                );
              },
            );
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
      _saveTasks();
      _filterTasks();
    });
  }

  void _loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      setState(() {
        tasks = (json.decode(tasksJson) as List)
            .map((task) => Task.fromMap(task))
            .toList();
        _filterTasks();
      });
    }
  }

  void _saveTasks() {
    String tasksJson = json.encode(tasks.map((task) => task.toMap()).toList());
    prefs.setString('tasks', tasksJson);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _filterTasks() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filteredTasks = tasks.where((task) {
        return task.title.toLowerCase().contains(searchTerm) ||
            task.description.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  int getTasksCount() {
    return tasks.length;
  }
}

class AddTaskAlertDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  AddTaskAlertDialog({required this.onTaskAdded});

  @override
  _AddTaskAlertDialogState createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return AlertDialog(
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      content: SizedBox(
        height: height * 0.5,
        width: width,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                controller: taskController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit, color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Task',
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                controller: descriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description, color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Description',
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Icon(Icons.date_range, color: Colors.black),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey.shade300,
                      ),
                      child: Text(
                        _formatDate(selectedDate),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Task task = Task(
              title: taskController.text,
              description: descriptionController.text,
              date: selectedDate,
            );
            widget.onTaskAdded(task);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}

class Task {
  String title;
  String description;
  DateTime date;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
