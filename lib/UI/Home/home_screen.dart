
import 'package:chat_app_firebase/UI/chat_screen.dart';
import 'package:chat_app_firebase/controller/layout_cubit.dart';
import 'package:chat_app_firebase/controller/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
final sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
   final layoutCubit= BlocProvider.of<LayoutCubit>(context)..getMyData()..getUsers();
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context, state) { 
       
      },
      builder: (context, state) {
        
        return Scaffold(
          key:sckey ,
          appBar: AppBar(title: layoutCubit.SearchEnabled ? TextFormField(
            style: TextStyle(color: Colors.white,),
            onChanged: (value) {
              layoutCubit.searchAboutUser(query: value);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'search about user...',
              hintStyle: TextStyle(color: Colors.white,),
            ),
          )   : GestureDetector(
            onTap: () {
              ///////////////////
            },
            child: Text('Chat')),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                child: Icon(layoutCubit.SearchEnabled ? Icons.clear: Icons.search,),
                onTap: () {
                  layoutCubit.changeSearchStatus();
                },
                ),
            ),
          ],
          
          ),
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(layoutCubit.userModel != null)
                UserAccountsDrawerHeader(
                  accountName:Text(layoutCubit.userModel!.name!), 
                  accountEmail: Text(layoutCubit.userModel!.email!),
                  currentAccountPicture:CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(layoutCubit.userModel!.image!),
                  ) ,
                  )

                ,Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading:Icon(Icons.logout) ,
                      title:Text('logout') ,
                    )

                  ],
                ) ),
              ],
            ),
          ),
      body:state is GetUsersLoadingState ?  
      Center(child: CircularProgressIndicator(),)
         : layoutCubit.users.isNotEmpty ?
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
           child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 12,);
            },
             itemCount:layoutCubit.usersFiltered.isEmpty ?  layoutCubit.users.length : layoutCubit.usersFiltered.length,
             itemBuilder: (BuildContext context, int index) {
               return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChatScreen(userModel: layoutCubit.usersFiltered.isEmpty? layoutCubit.users[index] : layoutCubit.usersFiltered[index] );
                  }),);
                },
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  
                  radius: 35,
                  backgroundImage: NetworkImage(
             layoutCubit.usersFiltered.isEmpty ?  layoutCubit.users[index].image! : layoutCubit.usersFiltered[index].image! ,
                    
                  ),
                  
                ),
                title: Text(layoutCubit.usersFiltered.isEmpty ? layoutCubit.users[index].name! :layoutCubit.usersFiltered[index].name! ),
               );
             },
           ),
         )
        : Center(
          child: Text('there is no users yet...'),
         )
          
    );
      }, );
  }
}