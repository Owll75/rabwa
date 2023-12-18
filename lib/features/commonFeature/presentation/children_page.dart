import 'package:rabwa/features/commonFeature/domain/user.dart';
import 'package:flutter/material.dart';

import '../data/patient_repository.dart';
import '../domain/patient.dart';
import 'medicines_page.dart';

class ChildrenPage extends StatefulWidget {
  final String parentID;

  ChildrenPage({super.key, required this.parentID});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  final PatientsDatasource patientsDatasourceDatasource = PatientsDatasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showAddPatientDialog(context, widget.parentID);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Patient>>(
        future:
            patientsDatasourceDatasource.getPatientsByParentId(widget.parentID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there is no data
            return const Text('No Children found.');
          } else {
            // If data is available, display it
            List<Patient> patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                Patient patient = patients[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.face, size: 30),
                      ),
                      title: Text(patient.name),
                      subtitle: Text("age: ${patient.age}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MedicinePage(patientId: patient.docId!),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void showAddPatientDialog(BuildContext context, String parentID) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String name = '';
    int age = 0;
    double height = 0.0;
    double weight = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add my child"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      age = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Height (cm)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter height';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      height = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter weight';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      weight = double.parse(value!);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Call method to add patient to database
                  // Example: addPatient(name, age, height, weight);
                  Patient newPatient = Patient(
                      age: age,
                      hight: height,
                      name: name,
                      weight: weight,
                      parentID: parentID);
                  await patientsDatasourceDatasource.addPatient(newPatient);

                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
