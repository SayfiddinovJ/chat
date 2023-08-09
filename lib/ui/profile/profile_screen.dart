import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenStateAdmin();
}

class _ProfileScreenStateAdmin extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<ProfileProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 31.h),
            Center(
              child:
              context.read<ProfileProvider>().currentUser!.photoURL == null
                  ? Icon(
                Icons.account_circle,
                size: 96.h,
              )
                  : Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 60,
                    foregroundImage: NetworkImage(
                      context
                          .read<ProfileProvider>()
                          .currentUser!
                          .photoURL!,
                      scale: 2,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 60,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                user?.email ?? 'Empty',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'Personal details',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Email address',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: context.read<ProfileProvider>().emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    splashRadius: 1,
                    onPressed: () {
                      context.read<ProfileProvider>().updateEmail(context);
                    },
                    icon: const Icon(Icons.upload_rounded)),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Edit email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFC8C8C8),
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: context.read<ProfileProvider>().passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    splashRadius: 1,
                    onPressed: () {},
                    icon: const Icon(Icons.upload_rounded)),
                filled: true,
                fillColor: Colors.white,
                hintText: 'New password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFC8C8C8),
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logOut(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
