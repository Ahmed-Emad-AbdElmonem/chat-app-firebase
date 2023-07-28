import 'package:chat_app_firebase/UI/Auth/auth_cubit.dart';
import 'package:chat_app_firebase/UI/Auth/auth_states.dart';
import 'package:chat_app_firebase/UI/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailConntroller = TextEditingController();
  final passConntroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('${state.message}'),
            ),
          );
        }

        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Done...'),
          ));

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      },
      builder: (context, state) {
       // final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailConntroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passConntroller,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () {
                  if (emailConntroller.text.isNotEmpty &&
                      passConntroller.text.isNotEmpty) {
                 BlocProvider.of<AuthCubit>(context).login(
                        email: emailConntroller.text,
                        password: passConntroller.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('please fill email, password')));
                  }
                },
                child: state is LoginLoadingState
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : const Text('Login'),
              ),
            ],
          ),
        );
      },
    ));
  }
}
