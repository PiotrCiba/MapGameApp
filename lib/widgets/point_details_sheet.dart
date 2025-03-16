import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/models/point_model.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/widgets/quizTask.dart';

class PointDetailsSheet extends StatelessWidget{
  final Point point;
  final AuthService authService;

  const PointDetailsSheet({
    super.key,
    required this.point,
    required this.authService,
  });

  bool _areRequirementsFulfilled(List<Map<String, dynamic>> requirements){
    //check if all requirements are fulfilled
    return true;
  }

    void _onTaskCompleted(BuildContext context) async {
    // Update the player's data to add the point's ID to the completedPoints list
    final user = await authService.getCurrentUser();
    if (user != null) {
      user.completedPoints.add(point.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool requirementsFulfilled = _areRequirementsFulfilled(point.requirements);

    return SingleChildScrollView(
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
                    return QuizTaskWidget(task: task, onTaskCompleted: () => _onTaskCompleted(context));
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