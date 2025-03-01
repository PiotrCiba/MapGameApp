// widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/models/route_model.dart' as route_model;

class AppDrawer extends StatelessWidget {
  final route_model.Route? currentRoute;
  final VoidCallback onEndRoute;
  final String? username;

  const AppDrawer({
    super.key,
    this.currentRoute,
    required this.onEndRoute,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildHeader(context),
          _buildOptionsSection(context),
          if (currentRoute!=null) _buildCurrentRouteSection(context),
          _buildLoginSection(context),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader( BuildContext context){
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
            CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://as1.ftcdn.net/jpg/01/12/43/90/1000_F_112439016_DkgjEftsYWLvlYtyl7gVJo1H9ik7wu1z.jpg'),
            ),
          Text(
            username ?? '[Username]',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context){
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.map),
          title: Text('Map'),
          onTap: () => Navigator.of(context).pushNamed('/'),
        ),
      ],
    );
  }

  Widget _buildCurrentRouteSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.directions),
          title: Text('Current Route: ${currentRoute!.title}'),
        ),
        ListTile(
          leading: Icon(Icons.stop),
          title: Text('End Route'),
          onTap: onEndRoute,
        ),
      ],
    );
  }

  Widget _buildLoginSection(BuildContext context){
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Login'),
          onTap: () => Navigator.of(context).pushNamed('/login'),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context){
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () => Navigator.of(context).pushNamed('/logout'),
        ),
      ],
    );
  }
}

