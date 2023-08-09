import 'package:chat/data/models/universal_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService{
  final user = FirebaseAuth.instance.currentUser;



  Future<UniversalData> updateuserEmail({required String email})async{
    try{
      await user?.updateEmail(email);
      return UniversalData(data: "Updated!");
    }on FirebaseAuthException catch(e){
      return UniversalData(error: e.code);
    }catch(e){
      return UniversalData(error: e.toString());
    }
  }
  Future<UniversalData> updateUserPassword({required String password})async{
    try{
      await user?.updatePassword(password);
      return UniversalData(data: "Updated!");
    }on FirebaseAuthException catch(e){
      return UniversalData(error: e.code);
    }catch(e){
      return UniversalData(error: e.toString());
    }
  }
}