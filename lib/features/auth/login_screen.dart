import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';

class LoginScreen extends StatelessWidget{
  static const String routeName = '/login';
  final AuthService authService;
  final CacheManager cacheManager;

  LoginScreen({
    super.key,
    required this.authService,
    required this.cacheManager,
  });

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    try{
                      await authService.login(email: email, password: password);
                      Navigator.of(context).pop();
                    } catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error logging in: $e')),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}