import 'package:ej_stepper/ej_stepper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EJ Stepper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'EJ Stepper Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String firstName;
  String lastName;

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: EJStepper(
        onLastStepConfirmTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    firstName != null &&
                            firstName.isNotEmpty &&
                            lastName != null &&
                            lastName.isNotEmpty
                        ? Icons.check_circle_outline
                        : Icons.close,
                    size: 100,
                    color: firstName != null &&
                            firstName.isNotEmpty &&
                            lastName != null &&
                            lastName.isNotEmpty
                        ? Colors.green
                        : Colors.red,
                  ),
                  SizedBox(height: 8),
                  Text(
                    firstName != null &&
                            firstName.isNotEmpty &&
                            lastName != null &&
                            lastName.isNotEmpty
                        ? 'Done'
                        : 'Fill all fields',
                    style: textTheme.headline5,
                  ),
                ],
              ),
            ),
          );
        },
        steps: [
          EJStep(
            title: Text(
              'First Name',
              style: textTheme.bodyText1,
            ),
            subtitle: firstName != null && firstName.isNotEmpty
                ? Text(
                    firstName,
                    style: textTheme.subtitle2.copyWith(color: Colors.grey),
                  )
                : null,
            leftWidget: Icon(
              Icons.person,
              size: 30,
            ),
            state: firstName != null && firstName.isNotEmpty
                ? EJStepState.complete
                : EJStepState.active,
            content: TextField(
              onChanged: (value) {
                setState(() {
                  firstName = value;
                });
              },
            ),
          ),
          EJStep(
              title: Text(
                'Last Name',
                style: textTheme.bodyText1,
              ),
              subtitle: lastName != null && lastName.isNotEmpty
                  ? Text(
                      lastName,
                      style: textTheme.subtitle2.copyWith(color: Colors.grey),
                    )
                  : null,
              leftWidget: Icon(
                Icons.perm_contact_calendar_rounded,
                size: 30,
              ),
              state: lastName != null && lastName.isNotEmpty
                  ? EJStepState.complete
                  : EJStepState.active,
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
              ),
              stepEnteredLeftWidget: Text('Hint: enter Your last Name')),
        ],
      ),
    );
  }
}
