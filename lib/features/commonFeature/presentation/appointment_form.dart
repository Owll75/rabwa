import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/domain/appointment.dart';
// import 'asthma_score.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  // A list to restore the patient names
  List<String> patientNames = [];
  // Variable to store the selected child
  String? selectedPatient;

  String? _selectedPatientName;
  List<String> _patientNames = [];
  final Map<String, bool?> _answers = {
    'AC1': null,
    'AC2': null,
    'AC3': null,
    'AC4': null,
  };
  final Map<String, bool?> _additionalAnswers = {
    'AC5': null,
    'AC6': null,
  };
  final Map<String, String> _validationErrors = {};

  bool get _isAdditionalQuestionsVisible =>
      _answers.values.where((v) => v == true).length >= 3;

  void _setResponse(String key, bool value) {
    setState(() {
      _answers.containsKey(key)
          ? _answers[key] = value
          : _additionalAnswers[key] = value;
      // If an answer is set, clear validation error if it exists
      if (_validationErrors.containsKey(key)) {
        _validationErrors.remove(key);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() async {
    if (user != null) {
      var patientDocs = await firestore
          .collection('Patient')
          .where('parent_id', isEqualTo: user!.uid)
          .get();

      List<String> fetchedPatientNames = [];
      for (var doc in patientDocs.docs) {
        if (doc.data().containsKey('doctor_id') &&
            doc['doctor_id'] != null &&
            doc['doctor_id'] != "") {
          String patientDisplayName = "${doc['name']} - ${doc['id']}";
          fetchedPatientNames.add(patientDisplayName);
        }
      }

      setState(() {
        patientNames = fetchedPatientNames;
      });
    }
  }

  void _onSubmit() async {
    if (_validateForm()) {
      try {
        // Assuming selectedPatient is in the format "Name - ID"
        var patientIdentifier = selectedPatient!.split(" - ").last;

        // Fetch patient's information
        var selectedPatientData = await _fetchPatientData(patientIdentifier);
        // Fetch parent's (user's) information
        var parentData = await _fetchParentData(user!.uid);

        Appointment newAppointment = Appointment(
          active: false,
          submitDate: DateTime.now(),
          doctorId: selectedPatientData['doctor_id'],
          parentName: parentData['name'],
          parentId: parentData['id'],
          patientId: selectedPatientData['id'],
          patientName: selectedPatientData['name'],
          patientAge: selectedPatientData['age'],
          patientWeight: selectedPatientData['weight'],
          patientHeight: selectedPatientData['height'],
          ac1: _answers['AC1'].toString(),
          ac2: _answers['AC2'].toString(),
          ac3: _answers['AC3'].toString(),
          ac4: _answers['AC4'].toString(),
          ac5: _answers['AC5'].toString(),
          ac6: _answers['AC6'].toString(),
        );

        // Save the new appointment to Firestore
        await _saveAppointment(newAppointment);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: $e')),
        );
      }
    }
  }

  bool _validateForm() {
    setState(() {
      _validationErrors.clear();
    });

    bool hasUnansweredQuestions = _answers.containsValue(null) ||
        (_isAdditionalQuestionsVisible &&
            _additionalAnswers.containsValue(null));

    if (hasUnansweredQuestions) {
      setState(() {
        _answers.forEach((key, value) {
          if (value == null) {
            _validationErrors[key] = 'Please answer this question';
          }
        });

        if (_isAdditionalQuestionsVisible) {
          _additionalAnswers.forEach((key, value) {
            if (value == null) {
              _validationErrors[key] = 'Please answer this question';
            }
          });
        }
      });
      return false;
    }

    return true;
  }

  Future<Map<String, dynamic>> _fetchPatientData(
      String patientIdentifier) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('Patient')
        .doc(patientIdentifier)
        .get();

    if (!docSnapshot.exists) {
      throw 'Patient not found';
    }

    return docSnapshot.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _fetchParentData(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (!userDoc.exists) {
      throw 'User not found';
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> _saveAppointment(Appointment appointment) async {
    await FirebaseFirestore.instance.collection('Appointments').add({
      'active': appointment.active,
      'submitDate': appointment.submitDate,
      'doctorId': appointment.doctorId,
      'parentName': appointment.parentName,
      'parentId': appointment.parentId,
      'patientId': appointment.patientId,
      'patientName': appointment.patientName,
      'patientAge': appointment.patientAge,
      'patientWeight': appointment.patientWeight,
      'patientHeight': appointment.patientHeight,
      'AC1': appointment.ac1,
      'AC2': appointment.ac2,
      'AC3': appointment.ac3,
      'AC4': appointment.ac4,
      'AC5': appointment.ac5,
      'AC6': appointment.ac6,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Assesement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (patientNames.isNotEmpty) _buildPatientDropdown(),
            ..._answers.keys.map((key) => _buildQuestionCard(
                  question: _getQuestionText(key),
                  responseKey: key,
                )),
            if (_isAdditionalQuestionsVisible)
              ..._additionalAnswers.keys.map((key) => _buildQuestionCard(
                    question: _getQuestionText(key),
                    responseKey: key,
                  )),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  String _getQuestionText(String key) {
    switch (key) {
      case 'AC1':
        return 'More than twice a week daytime symptoms?';
      case 'AC2':
        return 'Woke up in the night due to symptoms?';
      case 'AC3':
        return 'Used their reliever inhaler more than twice a week?';
      case 'AC4':
        return 'Activity limitations due to symptoms?';
      case 'AC5':
        return "How was your child's adherence to the inhaler?";
      case 'AC6':
        return 'Did you make sure your child avoids exposure to their allergic triggers?';
      default:
        return '';
    }
  }

  Widget _buildQuestionCard(
      {required String question, required String responseKey}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResponseButton(responseKey, false),
                _buildResponseButton(responseKey, true),
              ],
            ),
            // Display validation error if it exists for this question
            if (_validationErrors.containsKey(responseKey))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _validationErrors[responseKey]!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseButton(String key, bool value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: (_answers.containsKey(key)
                    ? _answers[key]
                    : _additionalAnswers[key]) ==
                value
            ? Colors.blue
            : Colors.white,
        onPrimary: Colors.black,
        side: BorderSide(
          color: (_answers.containsKey(key)
                      ? _answers[key]
                      : _additionalAnswers[key]) ==
                  value
              ? Colors.blue
              : Colors.grey.withOpacity(0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
      ),
      child: Text(value ? 'Yes' : 'No',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () => _setResponse(key, value),
    );
  }

  Widget _buildPatientDropdown() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15), // Add bottom padding
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
            color: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none, // Removes underline
              contentPadding: EdgeInsets.zero,
              // Optional: Add an icon
              icon: Icon(Icons.person, color: Colors.blue),
            ),
            value: selectedPatient,
            hint: const Text('Select the child',
                style: const TextStyle(color: Colors.black54)),
            onChanged: (newValue) {
              setState(() {
                selectedPatient = newValue;
              });
            },
            items: patientNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
            // Dropdown button style
            style: const TextStyle(fontSize: 16, color: Colors.black),
            dropdownColor: Colors.white,
          ),
        ));
  }
}





  
  // void _onSubmit() {
  //   // Reset validation errors
  //   setState(() {
  //     _validationErrors.clear();
  //   });

  //   bool hasUnansweredQuestions = _answers.containsValue(null) ||
  //       (_isAdditionalQuestionsVisible &&
  //           _additionalAnswers.containsValue(null));

  //   if (hasUnansweredQuestions) {
  //     setState(() {
  //       _answers.forEach((key, value) {
  //         if (value == null) {
  //           _validationErrors[key] = 'Please answer this question';
  //         }
  //       });

  //       if (_isAdditionalQuestionsVisible) {
  //         _additionalAnswers.forEach((key, value) {
  //           if (value == null) {
  //             _validationErrors[key] = 'Please answer this question';
  //           }
  //         });
  //       }
  //     });
  //   } else {
  //     // All questions answered, process the answers
  //     Navigator.of(context).pop();
  //   }
  // }