// widgets/quiz_task_widget.dart
import 'package:flutter/material.dart';

class QuizTaskWidget extends StatefulWidget {
  final Map<String, dynamic> task;
  final void Function() onTaskCompleted;

  const QuizTaskWidget({
    super.key,
    required this.task,
    required this.onTaskCompleted,
  });

  @override
  _QuizTaskWidgetState createState() => _QuizTaskWidgetState();
}

class _QuizTaskWidgetState extends State<QuizTaskWidget> {
  String? _selectedAnswer;
  bool _isCorrect = false;

  void _submitAnswer() {
    final content = widget.task['content'] ?? {};
    final List<dynamic> answers = content['answers'] ?? [];
    final int correctAnswerIndex = content['correctAnswer'] ?? -1;
    final String correctAnswer = correctAnswerIndex >= 0 && correctAnswerIndex < answers.length
        ? answers[correctAnswerIndex]
        : '';

    setState(() {
      _isCorrect = _selectedAnswer == correctAnswer;
    });

    if (_isCorrect) {
      widget.onTaskCompleted();
    } else {
      // show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.task['content'] ?? {};
    final String question = content['question'] ?? 'No question';
    final List<dynamic> answers = content['answers'] ?? [];
    final int correctAnswerIndex = content['correctAnswer'] ?? -1;
    final String correctAnswer = correctAnswerIndex >= 0 && correctAnswerIndex < answers.length
        ? answers[correctAnswerIndex]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz Task',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          question,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 8),
        ...answers.map((answer) => ListTile(
              title: Text(answer),
              leading: Radio<String>(
                value: answer,
                groupValue: _selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    _selectedAnswer = value;
                    _isCorrect = value == correctAnswer;
                  });
                },
              ),
            )),
        if (_selectedAnswer != null)
          Text(
            _isCorrect ? 'Correct!' : 'Incorrect. Try again.',
            style: TextStyle(
              color: _isCorrect ? Colors.green : Colors.red,
              fontSize: 16,
            ),
          ),
      ],
    );
  }
}