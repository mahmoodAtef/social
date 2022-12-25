import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/custom_icons.dart';
import 'package:lol/screens/update_user.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';

import '../models/user_model.dart';
import '../network/local/cache_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = UserModel();
    late var uid = CacheHelper.getData(key: 'uid')
        .then((value) => {
              print(
                'uuuuuiiiiidddd $value',
              ),
              AppCubit.get(context).getUserData(value)
            })
        .then((value) async {
      user = AppCubit.get(context).userModel;
      await AppCubit.get(context).getFollowing(user);
      await AppCubit.get(context).getFollowers(user);
      await AppCubit.get(context).getUserPosts(user);
    });
    print('my uid is: $uid');
    AppCubit.get(context).currentTab = 0;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        user = AppCubit.get(context).userModel;
      },
      builder: (context, state) {
        // AppCubit.get(context).getUserData(uid);
        if (user.name != null) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            '${user.cover}',
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius:
                                      MediaQuery.of(context).size.width / 8 + 1,
                                  child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 8,
                                    backgroundImage: NetworkImage(
                                      '${user.image}',
                                    ),
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ),
                              Center(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${user.name}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return UpdateData(model: user);
                                              }));
                                            },
                                            icon: const Icon(Icons.edit)))),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${user.bio}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: TabBar(
                                labelColor: Colors.black,
                                isScrollable: true,
                                tabs: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Following',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                            '${AppCubit.get(context).following.length}'),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Followers',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                            '${AppCubit.get(context).followers.length}'),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Posts',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                            '${AppCubit.get(context).userPosts.length}'),
                                      ),
                                    ],
                                  ),
                                ],
                                padding: const EdgeInsets.all(10),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                onTap: (index) {
                                  AppCubit.get(context).changeTab(index);
                                },
                              ),
                            ),
                          ],
                        ),
                        AppCubit.get(context).chooseTab(context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
