import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:lol/screens/home.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

TextEditingController userNameController = TextEditingController();
TextEditingController phoneNumController = TextEditingController();
TextEditingController bioController = TextEditingController();
TextEditingController BirthdayController = TextEditingController();

var formKey = GlobalKey<FormState>();

class CompleteData extends StatelessWidget {
  var uid ;

  CompleteData({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late File? imageFile = AppCubit.get(context).coverImage;
    late File? profile = AppCubit.get(context).profileImage;
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Complete account'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all( 8),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 4 + 40,
                              child: Stack(children: [
                                Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    imageFile == null
                                        ? Image(
                                            image: NetworkImage(
                                                'https://th.bing.com/th/id/OIP.8NzRO8ZwTnPh4JfAHPBIigHaDt?pid=ImgDet&rs=1'),
                                            width: double.infinity,
                                            errorBuilder: (context, child,
                                                    loadingProgress) =>
                                                Container(
                                              color: Colors.grey,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                          )
                                        : Image(
                                            image: FileImage(imageFile!),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                          ),
                                    FloatingActionButton(
                                        onPressed: () async {
                                          print('LLL');
                                          imageFile = await AppCubit.get(context)
                                              .changeCover(context);
                                          print('l');
                                        },
                                        child: const Icon(Icons.edit)),
                                  ],
                                ),
                              ], alignment: AlignmentDirectional.topCenter),
                            ),
                            Stack(
                              children: [
                                profile == null
                                    ? const CircleAvatar(
                                        radius: 57,
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundImage: NetworkImage(
                                            'https://th.bing.com/th/id/OIP.8NzRO8ZwT'
                                            'nPh4JfAHPBIigHaDt?pid=ImgDet&rs=1',
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                      )
                                    : CircleAvatar(
                                        radius: 57,
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundImage: FileImage(profile),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                CircleAvatar(
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      print('LLL');
                                      imageFile = await AppCubit.get(context)
                                          .changeProfile(context);
                                      print('l');
                                    },
                                    child: const Icon (
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    mini: true,
                                  ),
                                  radius: 15,
                                )
                              ],
                              alignment: AlignmentDirectional.bottomEnd,
                            ),
                          ],
                          alignment: AlignmentDirectional.bottomCenter,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 5),
                            labelText: 'User Name',
                            prefixIcon:
                                const Icon(Icons.drive_file_rename_outline_sharp),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter User Name';
                            }
                            return null;
                          },
                          controller: userNameController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 5),
                            labelText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          controller: phoneNumController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 5),
                            labelText: 'Bio',
                            prefixIcon:
                                const Icon(Icons.drive_file_rename_outline_sharp),
                          ),
                          keyboardType: TextInputType.text,
                          controller: bioController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: BirthdayController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 5),
                            labelText: 'Birth Day',
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
                              BirthdayController.text =
                                  value!.toLocal().toString().substring(0, 10);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container (
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: MaterialButton(
                            color: Colors.purple,
                            disabledElevation: 10,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                               AppCubit.get(context).uploadCover();
                               AppCubit.get(context).uploadProfile();
                                AppCubit.get(context)
                                    .createUser(
                                        name: userNameController.text,
                                        Bio: bioController.text,
                                        birthDay: BirthdayController.text,
                                        phone: phoneNumController.text,
                                        Uid: uid , image: AppCubit.get(context).profileUrl,
                                    cover: AppCubit.get(context).coverUrl)
                                    .then((value) => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(uid: uid,)),
                                          (route) => false)
                                })
                                    .catchError((error) {
                                  print(error.toString());
                                });
                              }
                            },
                            child: const Text('Save'),
                            textColor: Colors.white,
                            minWidth: double.infinity,
                            height: 45,
                            elevation: 10,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) => {});
  }
}
