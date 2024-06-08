// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, non_constant_identifier_names, sort_child_properties_last, prefer_const_constructors_in_immutables, depend_on_referenced_packages, constant_identifier_names, prefer_final_fields
import 'package:authflutter/models/todomodel/todo_model.dart';
import 'package:authflutter/pages/category_page.dart';
import 'package:authflutter/pages/description_page.dart';
import 'package:authflutter/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  // HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userId;
  final TextEditingController TextTodo = TextEditingController();
  final TextEditingController TextDescription = TextEditingController();
  final TextEditingController TextLevel = TextEditingController();
  String ValueDropDown = "Optional";

  @override
  void initState() {
    super.initState();
    //INitialize userId in initState

    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  final user = FirebaseAuth.instance.currentUser!;

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0; // Current index for BottomNavigationBar
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 249, 199),
        title: Text(
          "Welcome " +
              (user.email?.split('@').first.toUpperCase() ?? "Unknown user") +
              "!",
          style: TextStyle(fontSize: 15),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/images/pikaju.jpg'),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 249, 199),
      body: _buildUI(),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          onPressed: _displayTextInputDialog,
          child: Icon(
            Icons.add,
            color: Colors.lightBlue.shade300,
          ),
          backgroundColor: Color(0xFFE4717A), // Calypso Coral color
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          // Add more BottomNavigationBarItem if needed
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue.shade100,
        onTap: _onItemTapped,
      ),
    );
  }

  //FIX ME : OLD CODE
  Widget _buildUI() {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: [
          _messageListView(),
        ],
      )),
    );
  }

  Widget _messageListView() {
    return Center(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.80,
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: StreamBuilder(
          stream: _databaseService.getTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Add todo task"));
            }
            List todos = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index].data();
                String todoId = todos[index].id;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => testmethod(todoId),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        )
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 224, 86),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Column(
                          children: [
                            Text("Task: " + todo.task,
                                style: TextStyle(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              // DateFormat("dd-MM-yyyy h:mm a")
                              "Updated:" +
                                  DateFormat("dd-MM-yyyy ")
                                      .format(todo.updatedOn.toDate()),
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: todo.isDone,
                          onChanged: (value) {
                            Todo updatedTodo = todo.copyWith(
                                isDone: !todo.isDone,
                                updatedOn: Timestamp.now());
                            _databaseService.updateTodo(todoId, updatedTodo);
                          },
                        ),
                        onLongPress: () {
                          // _databaseService.deleteTodo(todoId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DescriptionPage(todo: todo)));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void testmethod(String todoId) {
    _databaseService.deleteTodo(todoId);
  }

  void _displayTextInputDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("ToDo"),
              content: Container(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: TextTodo,
                      decoration:
                          const InputDecoration(hintText: "Todo Task...."),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: TextDescription,
                      decoration:
                          const InputDecoration(hintText: "Description ...."),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButton<String>(
                      value: ValueDropDown,
                      icon: Icon(
                        Icons.menu,
                        color: Colors.lightBlue,
                      ),
                      isExpanded: true,
                      underline: Container(
                          height: 2,
                          color: const Color.fromARGB(255, 243, 25, 25)),
                      onChanged: (String? newValue) {
                        setState(() {
                          ValueDropDown = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'Optional', child: Text("Optional")),
                        DropdownMenuItem(
                            value: 'Important', child: Text('Important')),
                        DropdownMenuItem(
                            value: "Mandantory", child: Text("Mandantory")),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                    textColor: Colors.white,
                    child: Text("Save"),
                    color: Color.fromARGB(255, 90, 33, 235),
                    onPressed: () {
                      Todo todo = Todo(
                        task: TextTodo.text,
                        isDone: false,
                        updatedOn: Timestamp.now(),
                        createdOn: Timestamp.now(),
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        description: TextDescription.text.isEmpty
                            ? 'Nothing'
                            : TextDescription.text,
                        level: ValueDropDown,

                        // userId: FirebaseAuth.instance.currentUser!.uid
                      );
                      _databaseService.addTodo(todo);
                      Navigator.of(context).pop();
                      TextTodo.clear();
                      TextDescription.clear();
                    })
              ],
            );
          });
        });
  }
}
