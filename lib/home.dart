import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homework_to_do_list/data.dart';
import 'package:homework_to_do_list/widgets.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Assignment> assignments = [];
  Date bufferDate = Date.fromDateTime(DateTime.now());
  TextEditingController controller = TextEditingController();
  int sortMode = 0;
  String sortModeString = "Priority";
  int numModes = 5;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/data.txt");
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data);
  }

  Future<List<String>> _data() async {
    //Test 07/01/21 Other 6 false 2021-06-25 10:54:52.335569
    print("Loading");
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return contents.split("\n");
      } else {
        writeData('');
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  String saveData(Assignment a) {
    String result =
        "${a.formatName()} ${a.dueDate.toString()} ${a.subjectToString()} ${a.priority.toString()} ${a.isCreated.toString()} ${a.formatDate()}";
    return result;
  }

  void save() {
    String data = "";
    assignments.forEach((a) {
      data += "${saveData(a)}\n";
    });
    writeData(data);
  }

  @override
  void initState() {
    super.initState();
    _data().then((List<String> data) {
      data.forEach((d) => setState(() {
            if (Assignment.fromString(d) != null)
              assignments.add(Assignment.fromString(d));
          }));
      print(assignments);
      updateList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    save();
    controller.dispose();
  }

  _selectDueDate(BuildContext context, Assignment assignment) async {
    DateTime initDate = assignment.dueDate.toDateTime();
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 2),
        helpText: "Select Due Date");
    if (date != null)
      setState(() {
        assignment.dueDate = Date.fromDateTime(date);
      });
  }

  void updateList() {
    switch (sortMode) {
      case 0:
        Sort.sortPriority(assignments);
        break;
      case 1:
        Sort.sortDueDate(assignments);
        break;
      case 2:
        Sort.sortSubject(assignments);
        break;
      case 3:
        Sort.sortAlphabetically(assignments);
        break;
      case 4:
        Sort.sortOldest(assignments);
        break;
      case 5:
        Sort.sortNewest(assignments);
        break;
    }
  }

  void addAssignment() {
    bool createNew = true;
    assignments.forEach((element) {
      print(element.toString());
      if (element != null && !element.isCreated) createNew = false;
    });
    if (createNew) {
      assignments.insert(
          0,
          new Assignment(
              "", Date.fromDateTime(DateTime.now()), null, 0, false));
      print(assignments[0].timeOfCreation);
    }
  }

  Widget DefaultCard() {
    return StyledCard(
      raised: true,
      child: Text("There are no current assignments at the moment",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
    );
  }

  Widget CreateAssignment(BuildContext context, Assignment assignment) {
    return StyledCard(
        raised: true,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Container(
                          height: 40,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            controller: controller,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[400],
                              filled: true,
                              hintText: 'Name',
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => setState(() {
                          assignment.name = (controller.text != "")
                              ? controller.text
                              : "New Assignment";
                          controller.text = "";
                          assignment.isCreated = true;
                          save();
                          updateList();
                        }),
                      )),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => setState(() {
                          assignments.remove(assignment);
                          save();
                          updateList();
                        }),
                      )),
                ])),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                                height: 40,
                                child: TextContainer(text: "Due Date: ")))),
                    Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: () => _selectDueDate(context, assignment),
                          child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: TextContainer(
                                  text: assignment.dueDate.toString())),
                        ))
                  ],
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                                height: 40,
                                child: TextContainer(text: "Subject: ")))),
                    Expanded(
                      flex: 6,
                      child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            color: Pallete.textField,
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: DropdownButton(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    value: assignment.subjectToString(),
                                    onChanged: (String value) => setState(() {
                                      if (value == "Math")
                                        assignment.subject = Subject.MATH;
                                      else if (value == "Science")
                                        assignment.subject = Subject.SCIENCE;
                                      else if (value == "English")
                                        assignment.subject = Subject.ENGLISH;
                                      else if (value == "History")
                                        assignment.subject = Subject.HISTORY;
                                      else if (value == "Language")
                                        assignment.subject = Subject.LANGUAGE;
                                      else if (value == "Other")
                                        assignment.subject = Subject.OTHER;
                                    }),
                                    items: <String>[
                                      'Math',
                                      'Science',
                                      'English',
                                      'History',
                                      'Language',
                                      'Other',
                                    ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    icon: Icon(Icons.arrow_drop_down),
                                    dropdownColor: Pallete.bgCard,
                                  )))),
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                                height: 40,
                                child: TextContainer(text: "Priority: ")))),
                    Expanded(
                        flex: 6,
                        child: Slider(
                            inactiveColor: Pallete.textField,
                            activeColor: Colors.orange,
                            value: assignment.priority.toDouble(),
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: assignment.priority.toString(),
                            onChanged: (double value) => setState(() {
                                  assignment.priority = value.toInt();
                                })))
                  ],
                ))
          ],
        ));
  }

  Widget DisplayAssignment(Assignment assignment) {
    return StyledCard(
        raised: true,
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Container(
                              height: 40,
                              child: TextContainer(text: assignment.name)))),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => setState(() {
                        assignments.remove(assignment);
                        save();
                        updateList();
                      }),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => setState(() {
                          bool noInEdditing = true;
                          assignments.forEach((a) {
                            if (!a.isCreated) noInEdditing = false;
                          });
                          if (noInEdditing) {
                            assignment.isCreated = false;
                            controller.text = assignment.name;
                          }
                          updateList();
                        }),
                      )),
                ],
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Container(
                              height: 40,
                              child: TextContainer(text: "Due Date: ")))),
                  Expanded(
                      flex: 6,
                      child: Container(
                          height: 40,
                          child: TextContainer(
                              text: assignment.dueDate.toString(), textColor: (assignment.isOverDue()) ? Colors.red : Colors.black))),
                ],
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Container(
                              height: 40,
                              child: TextContainer(text: "Subject: ")))),
                  Expanded(
                      flex: 6,
                      child: Container(
                          height: 40,
                          child: TextContainer(
                              text: assignment.subjectToString()))),
                ],
              )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Container(
                            height: 40,
                            child: TextContainer(text: "Priority: ")))),
                Expanded(
                    flex: 6,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(children: [
                          Expanded(
                              flex: assignment.priority,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: (assignment.priority == 10)
                                          ? BorderRadius.all(Radius.circular(4))
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              bottomLeft: Radius.circular(4)),
                                      color: Pallete.accent),
                                  height: 8)),
                          Expanded(
                              flex: 10 - assignment.priority,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                    borderRadius: (assignment.priority == 0)
                                        ? BorderRadius.all(Radius.circular(4))
                                        : BorderRadius.only(
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4)),
                                    color: Pallete.textField),
                              ))
                        ])))
              ]))
        ]));
  }

  Widget AssignmentCard(BuildContext context, Assignment assignment) {
    if (assignment.isCreated)
      return DisplayAssignment(assignment);
    else
      return CreateAssignment(context, assignment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.accent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.accent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Pallete.bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              TitleCard(
                title: "Assingments",
                isHome: true,
              ),
              StyledCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 40, right: 10),
                        child:
                            Text("Sort by: ", style: TextStyle(fontSize: 20))),
                    Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: DropdownButton(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          value: sortModeString,
                          onChanged: (String value) => setState(() {
                            sortModeString = value;
                            if (sortModeString == "Priority")
                              sortMode = 0;
                            else if (sortModeString == "Due Date")
                              sortMode = 1;
                            else if (sortModeString == "Subject")
                              sortMode = 2;
                            else if (sortModeString == "A-Z")
                              sortMode = 3;
                            else if (sortModeString == "Oldest")
                              sortMode = 4;
                            else if (sortModeString == "Newest") sortMode = 4;
                            updateList();
                          }),
                          items: <String>[
                            'Priority',
                            'Due Date',
                            'Subject',
                            'A-Z',
                            'Oldest',
                            'Newest'
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          icon: Icon(Icons.arrow_drop_down),
                          dropdownColor: Pallete.bgCard,
                        ))
                  ],
                ),
              ),
              StyledCard(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: ListView(
                          children: (assignments.length > 0)
                              ? assignments
                                  .map((assignment) =>
                                      AssignmentCard(context, assignment))
                                  .toList()
                              : <Widget>[DefaultCard()]))),
              StyledCard(
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Text(
                              "Add an assignment by pressing the add button. Name your assignment, set a due date, give it a subject, and set it's priority. By hitting the check mark, the assignment saves to your list. Once finished with the assignment, you can hit the check mark again, and it will be removed from the list. For any more questions please contact me at: ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text("gcoxdev@gmail.com",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            Text(
                              "To find information on updates and my newest apps, follow my instagram account: ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text("@gcoxdev",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            Text(
                              "Thank you for downloading my app, and good luck with all your homework.",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          ])))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => addAssignment()),
          backgroundColor: Pallete.accent,
          child: Icon(Icons.add)),
    );
  }
}
