import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mobx/screens/login_screen.dart';
import 'package:todo_mobx/stores/login_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provider irá ajudar a acessar uma classe,
    //colocando ele acima dos widgets que precisam acessá-lo
    return Provider<LoginStore>( 
      create: (_) => LoginStore(),
      //dispose: (_, store) => store.dispose(),
      child: MaterialApp(
        title: 'MobX Tutorial',
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(iconColor: Colors.deepPurpleAccent),
          primaryColor: Colors.deepPurpleAccent,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.deepPurpleAccent, 
          ),
          scaffoldBackgroundColor: Colors.deepPurpleAccent,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
