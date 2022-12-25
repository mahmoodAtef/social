// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'complete_data.dart';

bool isvisible = false;
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
var uid;

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.purple.shade500,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.center,
                  ),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Sign up and enjoy with friends',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gapPadding: 5),
                                      labelText: 'Email address',
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Email Address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gapPadding: 5),
                                        labelText: 'Password',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              isvisible = !isvisible;
                                              AppCubit.get(context).changeVisibility(isvisible);
                                            },
                                            icon: !isvisible
                                                ? const Icon(
                                                    Icons.visibility_outlined)
                                                : const Icon(
                                                    Icons.visibility_off))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                    keyboardType: isvisible
                                        ? TextInputType.text
                                        : TextInputType.visiblePassword,
                                    obscureText: isvisible ? false : true,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gapPadding: 5),
                                      labelText: 'Confirm Password',
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            isvisible = !isvisible;
                                            AppCubit.get(context)
                                                .changeVisibility(isvisible);
                                          },
                                          icon: !isvisible
                                              ? const Icon(
                                                  Icons.visibility_outlined)
                                              : const Icon(
                                                  Icons.visibility_off)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please confirm password';
                                      }
                                      return null;
                                    },
                                    keyboardType: isvisible
                                        ? TextInputType.text
                                        : TextInputType.visiblePassword,
                                    obscureText: isvisible ? false : true,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.purple,
                                    ),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate() ==
                                            true) {
                                          AppCubit.get(context)
                                              .userRegister(
                                                emailController.text,
                                                passwordController.text,
                                              )
                                              .then((value) => {
                                                    // ignore: avoid_print
                                                    uid = value.user!.uid,
                                                    print('uid: ' +
                                                        value.user.uid),
                                                    if (state !=
                                                        AppRegisterErrorState())
                                                      {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            CompleteData(
                                                                              uid: uid,
                                                                            )),
                                                                (route) =>
                                                                    false)
                                                      }
                                                  })
                                              .catchError((error) {
                                            print(error.toString() + 'llll');
                                            Fluttertoast.showToast(
                                                msg: error.runtimeType
                                                    .toString(),
                                                backgroundColor: Colors.purple,
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_LONG);
                                          });
                                        }
                                      },
                                      child: const Text('Create account'),
                                      textColor: Colors.white,
                                      minWidth: double.infinity,
                                      height: 45,
                                      elevation: 5,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: const [
                                              Icon(Icons.facebook,
                                                  color: Colors.blue, size: 35),
                                              Text(' Sign up')
                                            ],
                                          ),
                                          textColor: Colors.black,
                                          height: 45,
                                          elevation: 5,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: const [
                                              CircleAvatar(
                                                child: Text(
                                                  'G',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                radius: 15,
                                              ),
                                              Text(' Sign up')
                                            ],
                                          ),
                                          textColor: Colors.black,
                                          height: 45,
                                          elevation: 5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'already have an account ?',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Sign in'))
                                    ],
                                  )
                                ],
                              ),
                            )))
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) => {});
  }
}
