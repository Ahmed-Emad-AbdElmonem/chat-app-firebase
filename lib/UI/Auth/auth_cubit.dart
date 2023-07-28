import 'dart:io';
import 'package:chat_app_firebase/UI/Auth/auth_states.dart';
import 'package:chat_app_firebase/core/constants.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(InitialStates());

  File? userImgFile;
  void getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if( pickedImage != null )
      {
        userImgFile = File(pickedImage.path);
        emit(UserImageSelectedSuccessState());
      }
    else
      {
        emit(UserImageSelectedErrorState());
      }
  }

  Future<String> uploadImageToStorage() async {
    debugPrint("File is : ${userImgFile}"); 
   // debugPrint("Base Name fro File is : ${basename(userImgFile!.path)}");
    Reference imageRef = FirebaseStorage.instance.ref(basename(userImgFile!.path));
    await imageRef.putFile(userImgFile!);
    return await imageRef.getDownloadURL();
  }





  // register
  void register({required String email,required String name,required String password}) async {
    emit(RegisterLoadingState());
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if( userCredential.user?.uid != null )
      {
        debugPrint("User Created success with uid : ${userCredential.user!.uid}");
        String imgUrl = await uploadImageToStorage();
        debugPrint("Image Url is : $imgUrl");
        await sendUserDataToFirestore(name: name, email: email, password: password, userID: userCredential.user!.uid,url: imgUrl );
        emit(UserCreatedSucessState());
      }
    }
    on FirebaseAuthException catch(e){
      debugPrint("Failed To Register, reason is : ${e.code}");
      if( e.code == "email-already-in-use" )
      {
        emit(UserCreatedErrorState(message: 'Email already in use'));
      }
      if( e.code == "weak-password" )
      {
        emit(UserCreatedErrorState(message: 'Weak Password'));
      }
    }
  }

  Future<void> sendUserDataToFirestore({required String url,required String name,required String email,required String password,required String userID}) async {
    UserModel userModel = UserModel(name: name, email: email, image: url, id: userID);
    try{
      await FirebaseFirestore.instance.collection('Users').doc(userID).set(userModel.toJson());
      emit(SaveUserDataOnFireStoreSuccessState());
    }
    on FirebaseException catch(e)
    {
      emit(FailedToSaveUserDataOnFireStoreState());
    }
  }

  void login({required String email,required String password}) async {
    emit(LoginLoadingState());
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if( userCredential.user?.uid != null )
      {
        // save id cache
        final sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString('userID', userCredential.user!.uid);
        Constants.userId = sharedPref.getString('userID');
        emit(LoginSuccessState());
      }
    }
    on FirebaseAuthException catch(e){
      print("Error is : ${e.code}");
      emit(LoginErrorState(message: '${e.code}'));
    }
  }
}










/*

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(InitialStates());

  void reg(
      {required String name,
      required String email,
      required String password}) async {
    emit(RegisterLoadingState());

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        
        password: password,
      );

      if (userCredential.user?.uid != null) {
        String imageUrl = await uploadImageToStorage();
        await sendUserDataToFireStore(
            name: name,
            email: email,
            pass: password,
            userId: userCredential.user!.uid,
            imageUrl: imageUrl);
        emit(UserCreatedSucessState());
      }
    } on FirebaseAuthException catch (e) {
     debugPrint('failed: ${e.code}');

      emit(UserCreatedErrorState(message: e.code));
    }
  }

  File? userImageFile;

  void getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      userImageFile = File(pickedImage.path);
      emit(UserImageSelectedSuccessState());
    } else {
      emit(UserImageSelectedErrorState());
    }
  }

/*
void uploadImageToStorage(): هذا هو اسم الدالة التي تقوم بتحميل الصورة إلى التخزين.

FirebaseStorage.instance: هذا هو مرجع إلى Firebase Storage الذي يتم استخدامه للتفاعل مع خدمة التخزين في Firebase.

ref(basename(userImageFile!.path)): هنا يتم إنشاء مرجع لملف الصورة المحددة. basename(userImageFile!.path) يستخدم للحصول على اسم الملف من المسار الكامل للصورة. المرجع المنشأ يستخدم هذا الاسم لتحديد مكان تخزين الصورة في Firebase Storage.
*/

  Future<String> uploadImageToStorage() async {
    Reference imageRef =
        // عشان نوصل للستوريج // يتم انشاء
        FirebaseStorage.instance.ref(basename(userImageFile!.path));
    // بياخد مسار الصورة ويروح يخزنه ويرفعه فى الفايرستورريج
    await imageRef.putFile(userImageFile!);
    // بيجيب اللينك بتاع الصورة اللى  اترفعت على الستوريج
    return await imageRef.getDownloadURL();
  }



// ارسال بيانات اليوزر للفايرستور
  Future<void> sendUserDataToFireStore({
    required String name,
    required String email,
    required String pass,
    required String userId,
    required String imageUrl,
  }) async {
    UserModel userModel =
        UserModel(name: name, email: email, id: userId, image: imageUrl);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userModel.toJson());
      emit(SaveUserDataOnFireStoreSuccessState());
    } on FirebaseException catch (e) {
      emit(FailedToSaveUserDataOnFireStoreState());
    }
  }

  void logIn({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid != null) {
        // save user id in sharedpref
        final sharedpref = await SharedPreferences.getInstance();
        await sharedpref.setString('userId', userCredential.user!.uid);
        Constants.userId = sharedpref.getString('userId');
        emit(LoginSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(message: '${e.code}'));
    }
  }
}
*/