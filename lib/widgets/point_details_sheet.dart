import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/models/point_model.dart';
import 'package:map_game_flutter/widgets/quizTask.dart';

class PointDetailsSheet extends StatelessWidget{
  final Point point;

  const PointDetailsSheet({
    super.key,
    required this.point,
  });

  bool _areRequirementsFulfilled(List<Map<String, dynamic>> requirements){
    //check if all requirements are fulfilled
    return true;
  }

  //widget to display the task details of a point. task type "quiz" has a question and and array of answers, and a correct answer
  


  @override
  Widget build(BuildContext context) {
    final bool requirementsFulfilled = _areRequirementsFulfilled(point.requirements);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            point.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(point.description),
          SizedBox(height: 16),
          Text('Coordinates: ${point.coordinates.latitude}, ${point.coordinates.longitude}'),
          SizedBox(height: 16),
          if (requirementsFulfilled && point.tasks.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...point.tasks.map((task){
                  if(task['type'] == 'quiz'){
                    return QuizTaskWidget(task: task);
                  }else{
                    return Text('Task type not supported');
                  }
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
}