import 'package:chat_app_firebase/UI/Auth/auth_cubit.dart';
import 'package:chat_app_firebase/UI/Auth/login_screen.dart';
import 'package:chat_app_firebase/UI/Auth/register_screen.dart';
import 'package:chat_app_firebase/UI/Home/home_screen.dart';
import 'package:chat_app_firebase/controller/layout_cubit.dart';
import 'package:chat_app_firebase/core/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   final sharedpref=   await SharedPreferences.getInstance();
 Constants.userId = sharedpref.getString('userId');
 await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider(create: (context)=> AuthCubit()),
       BlocProvider(create: (context)=>  LayoutCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
       
          primarySwatch: Colors.blue,
        ),
        home: Constants.userId != null ?  HomeScreen()    : LoginScreen(),
      ),
    );
  }
}
