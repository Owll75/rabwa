import 'package:flutter/material.dart';
// import 'asthma_score.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
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

  void _onSubmit() {
    // Reset validation errors
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
    } else {
      // All questions answered, process the answers
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Assesement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ..._answers.keys.map((key) => _buildQuestionCard(
                  question: _getQuestionText(key),
                  responseKey: key,
                )),
            if (_isAdditionalQuestionsVisible)
              ..._additionalAnswers.keys.map((key) => _buildQuestionCard(
                    question: _getQuestionText(key),
                    responseKey: key,
                  )),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Submit', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
                  style: TextStyle(color: Colors.red, fontSize: 14),
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
        padding: EdgeInsets.symmetric(horizontal: 45, vertical: 16),
      ),
      child: Text(value ? 'Yes' : 'No',
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () => _setResponse(key, value),
    );
  }
}
