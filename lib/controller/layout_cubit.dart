import 'package:chat_app_firebase/controller/layout_states.dart';
import 'package:chat_app_firebase/core/constants.dart';
import 'package:chat_app_firebase/models/message_model.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());


  static LayoutCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getMyData() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(Constants.userId!)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(data: value.data()!);
      });
      emit(GetMyDataSuccessState());
    } on FirebaseException catch (e) {
      emit(GetMyDataErrorState());
    }
  }

  List<UserModel> users = [];
  void getUsers() async {
    users.clear();
    emit(GetUsersLoadingState());
    try {
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var item in value.docs) {
          if (item != Constants.userId) {
            users.add(UserModel.fromJson(data: item.data()));
          }

          emit(GetUsersDataSuccessState());
        }
      });
    } on FirebaseException catch (e) {
      users = [];
      emit(GetUsersDataErrorState());
    }
  }

  List<UserModel> usersFiltered = [];

  void searchAboutUser({required String query}) {
    usersFiltered = users
        .where((element) =>
            element.name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    emit(FilteredUsersuccessState());
  }

  bool SearchEnabled = false;

  void changeSearchStatus() {
    SearchEnabled = !SearchEnabled;
    if (SearchEnabled == false) usersFiltered.clear();
    emit(ChangeSearchEnabledSuccessState());
  }

  void sendMessage({
    required String message,
    required String recieverID,
  })async {
    MessageModel messageModel = MessageModel(
        content: message,
        date: DateTime.now().toString(),
        senderID: Constants.userId);

       // save data on my doc
  await  FirebaseFirestore.instance
        .collection('Users')
        .doc(Constants.userId)
        .collection('Chat')
        .doc(recieverID).collection('Messages').add(messageModel.toJson());

       // save data on receiver doc
      await FirebaseFirestore.instance.collection('Users').doc(recieverID).collection('Chat')
       .doc(Constants.userId).collection('Messages').add(messageModel.toJson());
        emit(SendMessageSuccessState());
  }


  List<MessageModel> messages=[];
  void getMessages({required String recieverID}){
  
    emit(GetMessagesLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(Constants.userId).collection('Chat')
    .doc(recieverID).collection('Messages').orderBy('date').snapshots().listen((value) {
        messages.clear();
      for (var item in value.docs) {
        messages.add(MessageModel.fromJson(data: item.data()));
        
      }
      emit(GetMessagesSuccessState());
     });
  }
}
