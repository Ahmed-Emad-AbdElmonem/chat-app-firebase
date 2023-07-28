

import 'package:chat_app_firebase/controller/layout_cubit.dart';
import 'package:chat_app_firebase/controller/layout_states.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {

   ChatScreen({super.key, required this.userModel});
  final UserModel userModel;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   final layoutCubit = BlocProvider.of<LayoutCubit>(context)..getMessages(recieverID: userModel.id!);
    return Scaffold(
        appBar: AppBar(
          title: Text(userModel.name!),

        ),
        body:BlocConsumer<LayoutCubit,LayoutStates>(
          listener: (context, state) {
            if (state is SendMessageSuccessState) {
              messageController.clear();
              
            }
            
          },
          builder: (context, state) {
            return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
          child: Column(
            children: [
              Expanded(
                child:state is GetMessagesLoadingState  ? Center(
                  child: CircularProgressIndicator(color: Colors.amber,),
                )     : 
                layoutCubit.messages.isNotEmpty ?
                ListView.builder(
                  itemCount: layoutCubit.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.amber,
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                      child: Text(
                        
                        layoutCubit.messages[index].content!,
                      ),
                    );
                  },
                ) : Center(child: Text('No Messages yet'),)
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // send message to firestore
                      layoutCubit.sendMessage(
                        message: messageController.text,
                         recieverID: userModel.id!);
                    },
                    child: Icon(Icons.send),
                     ),
                  border: OutlineInputBorder(

                  )
                ),
              )
              
            ],
          ),
        );
          }, ),
    );
  }
}