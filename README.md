
# ej_stepper

Stepper with a brand new design.
Easy to use with similar properties to material stepper.

## Usage
<img src="https://imgur.com/WU3LtX4.gif" width="360" height="640">

```dart
EJStepper(
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
                     ) : null,
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
             ),  subtitle: lastName != null && lastName.isNotEmpty
                    ? Text(
                       lastName,
                       style: textTheme.subtitle2.copyWith(color: Colors.grey),
                      ) : null,
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
```