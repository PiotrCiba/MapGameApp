// widgets/route_details_sheet.dart
import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/models/route_model.dart' as route_model;

class RouteDetailsSheet extends StatefulWidget {
  final route_model.Route route;

  const RouteDetailsSheet({
    super.key,
    required this.route,
  });

  @override
  _RouteDetailsSheetState createState() => _RouteDetailsSheetState();
}

class _RouteDetailsSheetState extends State<RouteDetailsSheet> {
  bool _isInProgress = false;
  final bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              _buildHeader(),
              _buildRouteInfo(),
              _buildPointsList(),
              _buildActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.route.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Distance', '[placeholder] km'),
          _buildInfoRow('Difficulty', '[placeholder]'),
          _buildInfoRow('Required Tasks', '[placeholder]'),
          _buildInfoRow('Estimated Time', '[placeholder]'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPointsList() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route Points (${widget.route.points.length})',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.route.points.length,
            itemBuilder: (context, index) {
              final point = widget.route.points[index];
              return ListTile(
                leading: Icon(Icons.place),
                title: Text(point.name),
                subtitle: Text('${point.coordinates.latitude}, ${point.coordinates.longitude}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!widget.route.isCompleted)
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() => _isInProgress = true);
                  widget.route.isCompleted = true;
                  if (_isCompleted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error completing route: $e')),
                  );
                } finally {
                  setState(() => _isInProgress = false);
                }
              },
              child: Text(_isInProgress ? 'Completing...' : 'Complete Route'),
            ),
        ],
      ),
    );
  }
}