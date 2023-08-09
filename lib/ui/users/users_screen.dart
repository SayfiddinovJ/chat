import 'package:chat/data/models/user_model.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/ui_utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'),),
      body: StreamBuilder<List<UserModel>>(
              stream: context.read<UsersProvider>().getUser(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserModel>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isNotEmpty
                      ? ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              UserModel userModel = snapshot.data![index];
                              return ListTile(
                                title: Text(userModel.userName.capitalize()),
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("Empty!"));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}