import 'package:chat_app_firebase/UI/Auth/auth_cubit.dart';
import 'package:chat_app_firebase/UI/Auth/auth_states.dart';
import 'package:chat_app_firebase/UI/Auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registercreen extends StatelessWidget {
  Registercreen({super.key});

  final emailConntroller = TextEditingController();
  final passConntroller = TextEditingController();
  final nameConntroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is UserCreatedErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('${state.message}'),
              ),
            );
          }

          if (state is UserCreatedSucessState) {
             
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Done...'),
            ));

              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
             
          }

        },
        builder: (context, state) {
       //final AuthCubit  authCubit =  BlocProvider.of<AuthCubit>(context);
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 
                 BlocProvider.of<AuthCubit>(context).userImgFile != null ?
         Center(
           child: Column(
             children: [
               CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(BlocProvider.of<AuthCubit>(context).userImgFile!),
               ),
               const SizedBox(height: 10,),
               GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).getImage();
                },
                child: const Icon(Icons.image,),
               ),
             ],
           ),
         ) :
         OutlinedButton(
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).getImage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 const Icon(Icons.image,color: Colors.green,),
                 const SizedBox(width: 7,),
                 const Text('select photo'),
            ],
          ),
         ),
          const SizedBox(height: 20,),
                TextFormField(
                  controller: nameConntroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'name',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: emailConntroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passConntroller,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    if (emailConntroller.text.isNotEmpty &&
                        passConntroller.text.isNotEmpty) {
                      BlocProvider.of<AuthCubit>(context).register(
                        name: nameConntroller.text,
                          email: emailConntroller.text,
                          password: passConntroller.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('please fill email, password')));
                    }
                  },
                  child: state is RegisterLoadingState ? const CircularProgressIndicator(color: Colors.blue,)   : const Text('Sign Up'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
