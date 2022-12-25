import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lol/models/user_model.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

TextEditingController userNameController = TextEditingController();
TextEditingController phoneNumController = TextEditingController();
TextEditingController bioController = TextEditingController();
TextEditingController BirthdayController = TextEditingController();
var formKey = GlobalKey<FormState>();

class UpdateData extends StatelessWidget {
  UserModel model = UserModel();
  // TextEditingController userNameController = TextEditingController();
  //  TextEditingController phoneNumController = TextEditingController();
  //  TextEditingController bioController = TextEditingController();
  //  TextEditingController BirthdayController = TextEditingController();

  UpdateData({required this.model, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    late File? imageFile = AppCubit.get(context).coverImage;
    late File? profile = AppCubit.get(context).profileImage;
    bool isLoading = false;
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          late File? cover = AppCubit.get(context).coverImage;
          late File? profile = AppCubit.get(context).profileImage;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Update'),
              actions: [
                TextButton(
                    onPressed: () async {
                      {
                        isLoading = true;
                        Fluttertoast.showToast(
                            msg: 'Please wait .. don\'t close this page',
                            toastLength: Toast.LENGTH_LONG);
                        if (cover != null) {
                          await AppCubit.get(context)
                              .uploadCover()
                              .then((value) {
                            model.cover = AppCubit.get(context).coverUrl;
                            print('new cover : ${model.cover}');
                          });
                        }
                        if (profile != null) {
                          await AppCubit.get(context)
                              .uploadProfile()
                              .then((value) {
                            model.image = AppCubit.get(context).profileUrl;
                            print('new profile' + model.image.toString());
                          });
                        }
                        await AppCubit.get(context)
                            .updateUser(userModel: model, context: context)
                            .then((value) {
                          // Navigator.pop(context);
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text('Update'),
                    ))
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            image: cover == null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                      '${model.cover}',
                                                    ),
                                                    fit: BoxFit.cover)
                                                : DecorationImage(
                                                    image: FileImage(
                                                      cover,
                                                    ),
                                                    fit: BoxFit.cover)),
                                      ),
                                      FloatingActionButton(
                                          mini: true,
                                          onPressed: () async {
                                            print('LLL');
                                            imageFile =
                                                await AppCubit.get(context)
                                                    .changeCover(context);
                                            print('l');
                                          },
                                          child: const Icon(Icons.edit)),
                                    ],
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: profile == null
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8 +
                                                  1,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8,
                                                backgroundImage: NetworkImage(
                                                  '${model.image}',
                                                ),
                                                backgroundColor: Colors.grey,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8 +
                                                  1,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8,
                                                backgroundImage: FileImage(
                                                  profile,
                                                ),
                                                backgroundColor: Colors.grey,
                                              ),
                                            ),
                                    ),
                                    FloatingActionButton(
                                        mini: true,
                                        onPressed: () async {
                                          print('LLL');
                                          profile = await AppCubit.get(context)
                                              .changeProfile(context);
                                          print('l');
                                        },
                                        child: const Icon(Icons.edit)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              model.name = value;
                            },
                            decoration: InputDecoration(
                              hintText: model.name,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 5),
                              labelText: model.name,
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              prefixIcon: const Icon(
                                  Icons.drive_file_rename_outline_sharp),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter User Name';
                              }
                              return null;
                            },
                            controller: userNameController,
                            // initialValue: model.name != null ?model.name : '',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              model.phone = value;
                            },
                            decoration: InputDecoration(
                              hintText: model.phone,
                              labelText: model.phone,
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 5),
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            controller: phoneNumController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              model.bio = value;
                            },
                            decoration: InputDecoration(
                              hintText: model.bio,
                              labelText: model.bio,
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 5),
                              prefixIcon: const Icon(
                                  Icons.drive_file_rename_outline_sharp),
                            ),
                            keyboardType: TextInputType.text,
                            controller: bioController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              model.birthDay = value;
                            },
                            controller: BirthdayController,
                            decoration: InputDecoration(
                              hintText: model.birthDay,
                              labelText: model.birthDay,
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 5),
                              prefixIcon: const Icon(Icons.calendar_month),
                            ),
                            keyboardType: TextInputType.none,
                            onTap: () {
                              AppCubit.get(context).ChoseDate();
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.utc(1950),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                BirthdayController.text = value!
                                    .toLocal()
                                    .toString()
                                    .substring(0, 10);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container()
                          // Container (
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(30),
                          //     color: Colors.white,
                          //   ),
                          //   clipBehavior: Clip.antiAlias,
                          //   // child: MaterialButton(
                          //   //   color: Colors.purple,
                          //   //   disabledElevation: 10,
                          //   //   onPressed: () {
                          //   //     if (formKey.currentState!.validate()) {
                          //   //       AppCubit.get(context).uploadCover();
                          //   //       AppCubit.get(context).uploadProfile();
                          //   //       AppCubit.get(context)
                          //   //           .createUser(
                          //   //           name: userNameController.text,
                          //   //           Bio: bioController.text,
                          //   //           birthDay: BirthdayController.text,
                          //   //           phone: phoneNumController.text,
                          //   //           Uid: model.Uid , image: AppCubit.get(context).profileUrl,
                          //   //           cover: AppCubit.get(context).coverUrl)
                          //   //           .then((value) => {
                          //   //         Navigator.pushAndRemoveUntil(
                          //   //             context,
                          //   //             MaterialPageRoute(
                          //   //                 builder: (context) =>
                          //   //                     HomeScreen(uid: model.Uid,)),
                          //   //                 (route) => false)
                          //   //       })
                          //   //           .catchError((error) {
                          //   //         print(error.toString());
                          //   //       });
                          //   //     }
                          //   //   },
                          //   //   child: const Text('Save'),
                          //   //   textColor: Colors.white,
                          //   //   minWidth: double.infinity,
                          //   //   height: 45,
                          //   //   elevation: 10,
                          //   // ),
                          // ),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
        listener: (context, state) => {isLoading});
  }
}
