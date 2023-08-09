import 'package:chat/providers/auth_provider.dart';
import 'package:chat/ui/auth/sign_in/sign_in_page.dart';
import 'package:chat/ui_utils/error_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider x = context.read<AuthProvider>();
    AuthProvider y = context.watch<AuthProvider>();
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 240, 240),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.h, right: 20.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Text(
                            'Create an Account',
                            style: TextStyle(
                              fontFamily: 'Fjalla',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.032,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.019),
                              color: Colors.black12,
                            ),
                            child: TextFormField(
                              controller: x.emailController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon:
                                      Icon(Icons.person_outline_outlined),
                                  labelText: "Username",
                                  labelStyle: TextStyle(
                                    fontFamily: 'Fjalla',
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.019),
                              color: Colors.black12,
                            ),
                            child: TextFormField(
                              controller: x.passwordController,
                              obscureText: y.obscureText,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(x.obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      x.obs1();
                                    },
                                  ),
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Fjalla',
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.019),
                              color: Colors.black12,
                            ),
                            child: TextFormField(
                              controller: x.repeatPasswordController,
                              obscureText: y.obscureText1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(x.obscureText1
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      x.obs2();
                                    },
                                  ),
                                  labelText: "Repeat Password",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Fjalla',
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            0.01),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                if (x.emailController.text.isNotEmpty &&
                                    x.passwordController.text.isNotEmpty &&
                                    x.repeatPasswordController.text
                                        .isNotEmpty) {
                                  await x.createUser(context);
                                } else {
                                  showErrorMessage(
                                      message:
                                          "Qaysidir qatorni kiritishni unutdingiz!?",
                                      context: context);
                                }
                              },
                              child: const Center(
                                child: Text('Register'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const SignInPage()),
                                    ),
                                    (route) => false),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
