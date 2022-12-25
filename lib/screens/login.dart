// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/network/local/cache_helper.dart';
import 'package:lol/screens/register.dart';


TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isvisible = false;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) async {
        print(state.toString() + 'mm');
      },
      builder: (context, state) {
        state = AppLoginPasswordState();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade500,
                    Colors.purple,
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
                          'LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Login now and enjoy with friends',
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        gapPadding: 5),
                                    labelText: 'Email address',
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter email address';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  keyboardType: isvisible
                                      ? TextInputType.text
                                      : TextInputType.visiblePassword,
                                  obscureText: isvisible ? false : true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            print(state.toString() +
                                                '$isvisible');
                                            isvisible = !isvisible;
                                            AppCubit.get(context)
                                                .changeVisibility(isvisible);
                                            print(state.toString() +
                                                '$isvisible');
                                          },
                                          icon: !isvisible
                                              ? const Icon(
                                                  Icons.visibility_outlined)
                                              : const Icon(
                                                  Icons.visibility_off)),
                                      labelText: 'Password'),
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
                                      if (formKey.currentState!.validate()) {
                                        AppCubit.get(context)
                                            .userLogin(
                                                emailController.text,
                                                passwordController.text,
                                                context)
                                            .then((value) {});
                                      }
                                    },
                                    child: const Text('Login'),
                                    textColor: Colors.white,
                                    minWidth: double.infinity,
                                    height: 45,
                                    elevation: 5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                MaterialButton(
                                  onPressed: () {},
                                  child: const Text('Forgot password ?'),
                                  textColor: Colors.black,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Icon(Icons.facebook,
                                                color: Colors.blue, size: 35),
                                            Text(' Sign in')
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
                                        borderRadius: BorderRadius.circular(30),
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
                                            Text(' Sign in')
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
                                      'Don\'t have an account ?',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterScreen()));
                                        },
                                        child: const Text('Sign Up'))
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
        ;
      },
    );
  }
}
