// widgets/quiz_task_widget.dart
import 'package:flutter/material.dart';

class QuizTaskWidget extends StatelessWidget {
  final Map<String, dynamic> task;

  const QuizTaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String question = task['question'] ?? 'No question';
    final List<dynamic> answers = task['answers'] ?? [];
    final String correctAnswer = task['correctAnswer'] ?? '';

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
                groupValue: correctAnswer,
                onChanged: (value) {
                  // Handle answer selection
                },
              ),
            )),
      ],
    );
  }
}