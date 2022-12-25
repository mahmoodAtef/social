// ignore_for_file: avoid_print, dead_code, invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/constants.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/models/comment_model.dart';
import 'package:lol/models/message_model.dart';
import 'package:lol/models/user_model.dart';
import 'package:lol/network/local/cache_helper.dart';
import 'package:lol/pages/chat.dart';
import 'package:lol/pages/users.dart';
import 'package:lol/screens/home.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import '../custom_icons.dart';
import '../models/post_model.dart';
import '../pages/home_page.dart';
import '../pages/profile.dart';
import '../screens/register.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppLoginInistialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int current = 0;
  int currentTab = 0;

  List<ScrollNavigationItem> bottomitems = [
    const ScrollNavigationItem(icon: Icon(CustomIcons.account_circle)),
    const ScrollNavigationItem(
      icon: Icon(CustomIcons.home),
    ),
    const ScrollNavigationItem(
      icon: Icon(CustomIcons.users),
    ),
    const ScrollNavigationItem(
      icon: Icon(CustomIcons.chat_empty),
    ),
  ];
  List<Widget> Screens = [
    const ProfilePage(),
    const HomePage(),
    const UsersPage(),
    const ChatPage()
  ];

  Widget chooseTab(
    context,
  ) {
    Widget widget = Container();
    switch (currentTab) {
      case 0:
        {
          widget = following.length != 0
              ? SingleChildScrollView(
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          followingBuilder(following[index], context),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                      itemCount: following.length),
                )
              : Container();
        }
        break;
      case 1:
        {
          widget = followers.length != 0
              ? SingleChildScrollView(
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          followingBuilder(followers[index], context),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                      itemCount: followers.length),
                )
              : Container();
        }
        break;
      case 2:
        {
          {
            widget = userPosts.length != 0
                ? SingleChildScrollView(
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => PostBuilder(
                            context,
                            CarouselController(),
                            userPosts[index],
                            index,
                            appUSer,
                            commentImage),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 5,
                            ),
                        itemCount: userPosts.length),
                  )
                : Container();
          }
        }
        break;
      case 3:
        {
          widget = const SizedBox();
        }
    }
    return widget;
  }

  void Change(int index) {
    current = index;
    emit(changeBottomNav());
  }

  void changeTab(int index) {
    currentTab = index;
    emit(changeTabState());
  }

  // ignore: non_constant_identifier_names /////
  Future userRegister(
    email,
    password,
  ) async {
    emit(AppRegisterLoadingState());
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(AppRegisterSuccessfulState());
      return value;

      CacheHelper.saveData(key: 'uid', value: value.user!.uid);
      userId = value.user!.uid;
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message.toString(), toastLength: Toast.LENGTH_LONG);
      emit(AppRegisterErrorState());

      return error;
    });
  } // done

  Future userLogin(email, password, context) {
    var uid;
    emit(AppLoginLoadingState());
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(AppLoginSuccessfulState());

      CacheHelper.saveData(key: 'uid', value: value.user!.uid)
          .then((value) => {});
      uid = value.user!.uid;
      userId = value.user!.uid;

      CacheHelper.saveData(key: 'isLogin', value: true);
      CacheHelper.saveData(key: 'uid', value: uid);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    uid: uid,
                  )),
          (route) => false);
      Fluttertoast.showToast(
          msg: 'Login Successfully', toastLength: Toast.LENGTH_LONG);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message.toString(), toastLength: Toast.LENGTH_LONG);
      emit(AppLoginErrorState());
    });
  } // done

  void changeVisibility(bool visible) {
    emit(AppLoginPasswordState());
    visible = !visible;
  } //done

  var coverImage;

  var picker = ImagePicker();
  Future changeCover(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      coverImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChangeCoveState());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      coverImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChangeCoveState());
                    Navigator.pop(context);
                  },
                )
              ],
              title: const Text('Chose image'),
            ));
  }

  var profileImage;
  Future changeProfile(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      profileImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChangeProfileState());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      profileImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChangeProfileState());
                    Navigator.pop(context);
                  },
                )
              ],
              title: const Text('Chose image'),
            ));
  }

  ChoseDate() {
    emit(BirthDayState());
  }

  Future createUser(
      {required String name,
      String? phone,
      String? Bio,
      String? birthDay,
      String? Uid,
      String? image,
      String? cover,
      context}) async {
    UserModel userModel = UserModel(
        name: name,
        uid: uid,
        phone: phone,
        bio: Bio,
        birthDay: birthDay,
        image: image,
        cover: cover);
    FirebaseFirestore.instance
        .collection('users')
        .doc(Uid.toString())
        .set(userModel.ToJson())
        .then((value) {
      emit(
        CreateUserSuccessfulState(),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }).catchError((error) {

      emit(CreateUserErrorState());
    });
  }

  late dynamic profileUrl;

  Future<void> uploadProfile() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        profileUrl = value;
      }).catchError((error) {

      });
    });
  }

  late dynamic coverUrl;
  Future<void> uploadCover() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        coverUrl = value;
      }).catchError((error) {

      });
    });
  }

  UserModel userModel = UserModel();

  getUserData(userId) async {

    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      emit(GetUserSuccessfulState());

      userModel = UserModel.FromJson(value.data());
      appUSer = UserModel.FromJson(value.data());
      emit(GetUserSuccessfulState());
    }).catchError((error) {
      emit(GetUserErrorState());
    });
    return userModel;
  }

  updateUser({required UserModel userModel, context}) {
    assert(UserModel != null);
    emit(UpdateUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .update(userModel.ToJson())
        .then((value) {
      emit(UpdateUserSuccessfulState());
      Navigator.pop(
        context,
      );
      emit(UpdateUserSuccessfulState());
    }).catchError((error) {

      emit(UpdateUserErrorState());
    });
  }

  List<File> imagesList = [];

  Future addPostImages(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    await picker
                        .pickMultiImage(
                      maxHeight: MediaQuery.of(context).size.width,
                    )
                        .then((value) {
                      if (value != null) {
                        value.forEach((element) {
                          imagesList.add(File(element.path));

                        });
                      }
                    });
                    emit(ChangeCoveState());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera),
                  onTap: () async {
                    await picker
                        .pickImage(source: ImageSource.camera)
                        .then((value) {
                      if (value != null) {
                        imagesList.add(File(value.path));
                      }
                    });
                    emit(ChangeCoveState());
                    Navigator.pop(context);
                  },
                )
              ],
              title: const Text('Chose image'),
            ));
  }

  void removeImage(List list, e) {
    list.remove(e);
    emit(RemoveImageState());
  }

  createPost({required PostModel post, context}) async {
    await uploadImages(imagesList);
    emit(CreatePostLoadingState());
    post.postImages = postImagesUrls;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(userId)
        .collection('posts')
        .add(post.toJosn())
        .then((value) {
      emit(
        CreatePostSuccessfulState(),
      );
      AppCubit.get(context).imagesList.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }).catchError((error) {
      print(error.toString() + 'error');
      emit(CreatePostErrorState());
    });
  }

  List<String> postImagesUrls = [];
  bool liked = false;
  List<PostModel> userPosts = [];
  List<PostModel> allPosts = [];

  List<String> postUids = [];
  int likes = 0;
  getUserPosts(UserModel user) {
    userPosts.clear();
    emit(GetUserPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(userId)
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      postUids.clear();
      value.docs.forEach((element) async {
        PostModel post = PostModel.FromJson(element.data());
        postUids.add(element.id);
        await element.reference.collection('likes').get().then((value) {
          print(value.docs.length);
          post.likes = value.docs.length;
          value.docs.forEach((element) {
            if (element.id == user.uid) {
              print(element.id);
              post.isLiked = true;
            }
          });
        }).then((value) async {
          await element.reference.collection('comments').get().then((value) {
            print(value.docs.length);
            post.comments = value.docs.length;
          });
        });
        userPosts.add(post);
        emit(GetUserPostsSuccessfulState());
        print(post.likes);
      });
      emit(GetUserPostsSuccessfulState());
      print(state);
    }).catchError((e) {
      emit(GetUserPostsErrorState());
      print(e.toString());
    });
  }

  Future<List<PostModel?>> getAllPosts(UserModel user) async {
    emit(GetAllPostsLoadingState());
    getFollowing(user).then((value) async {
      allPosts = [];
      Set ids = followingIDs.toSet();
      ids.forEach((element) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(element)
            .collection('posts')
            .orderBy('dateTime')
            .get()
            .then((value) {
          postUids.clear();
          value.docs.forEach((element) async {
            PostModel post = PostModel.FromJson(element.data());
            postUids.add(element.id);
            await element.reference.collection('likes').get().then((value) {

              post.likes = value.docs.length;
              value.docs.forEach((element) {
                if (element.id == user.uid) {

                  post.isLiked = true;
                }
              });
            }).then((value) async {
              await element.reference
                  .collection('comments')
                  .get()
                  .then((value) {

                post.comments = value.docs.length;
              });
            });
            allPosts.add(post);
            emit(GetAllPostsSuccessfulState());

          });
          emit(GetUserPostsSuccessfulState());
        }).catchError((e) {
          emit(GetUserPostsErrorState());

        });
      });
    });
    emit(GetAllPostsSuccessfulState());
    return allPosts;
  }

  int index = 1;
  int scrollCarousel(double i, PostModel post) {
    post.photoIndex = i.toInt();
    emit(ScrollImageState());
    return post.photoIndex;
  }

  uploadImages(List<File> images) async {
    emit(UploadImagesLoadingState());
    postImagesUrls.clear();
    {
      for (var element in images) {
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('users/$userId')
            .child(Uri.file(element.path).pathSegments.last)
            .putFile(element)
            .then((value) async {
          await value.ref.getDownloadURL().then((value) {
            postImagesUrls.add(value);

          });
        }).catchError((error) {

        });
        if (element != images.last) {

        } else {
          continue;
        }
      }
    }

  }

  add_removeLikes(
    PostModel post,
    String postUid,
  ) async {
    if (post.isLiked == false) {
      post.likes = (post.likes! + 1);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.uid)
          .collection('posts')
          .doc(postUid)
          .collection('likes')
          .doc(userId)
          .set({'like': true}).then((value) {
        emit(LikePostSuccessfulState());
      }).catchError((error) {
        emit(LikePostErrorState());

      });
    } else {
      post.likes = (post.likes! - 1);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.uid)
          .collection('posts')
          .doc(postUid)
          .collection('likes')
          .doc(userId)
          .delete()
          .then((value) {
        emit(LikePostSuccessfulState());
      }).catchError((error) {
        emit(LikePostErrorState());

      });
    }
    post.isLiked = !post.isLiked!;
    emit(LikePostSuccessfulState());
  }

  dynamic commentImage = File('');
  late String? commentImageUrl = '';
  Future chooseCommentImage(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      commentImage = File(pickedImage.path);
                    } else {
                      print('No image Selected');
                    }
                    emit(ChooseImageState());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      commentImage = File(pickedImage.path);
                    } else {
                      print('No image Selected');
                    }
                    emit(ChangeProfileState());
                    Navigator.pop(context);
                  },
                )
              ],
              title: const Text('Chose image'),
            ));
  }

  void removeCommentImage() {
    commentImage = File('');
    emit(RemoveImageState());
  }

  Future<void> uploadCommentImage() async {
    emit(UploadCommentImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(commentImage.path).pathSegments.last}')
        .putFile(commentImage)
        .then((value) async {
      //   emit(UploadCommentImageSuccessFullState());
      await value.ref.getDownloadURL().then((value) {
        commentImageUrl = value;
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  addComment(PostModel post, String postUid, CommentModel comment) async {
    if (commentImage.path != '') {
      await uploadCommentImage().then((value) {
        emit(AddCommentLoadingState());
        print('image uploaded Successfully');

        print(comment.toString());
        comment.image = commentImageUrl;
        FirebaseFirestore.instance
            .collection('posts')
            .doc(post.uid)
            .collection('posts')
            .doc(postUid)
            .collection('comments')
            .add(comment.toJosn())
            .then((value) {

          emit(AddCommentSuccessfulState());
        }).catchError((error) {
          emit(AddCommentErrorState());
          print(error.toString());
        });
      });
    } else {
      emit(AddCommentLoadingState());
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.uid)
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .add(comment.toJosn())
          .then((value) {
        emit(AddCommentSuccessfulState());
      }).catchError((error) {
        emit(AddCommentErrorState());
        print(error.toString());
      });
    }
  }

  List<CommentModel> comments = [];
  Future getComments(PostModel post, String postUid) async {
    comments = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.uid)
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.FromJson(element.data()));
      });

    });
  }

  follow_unFollowUser(UserModel user, bool isFollowing) {
    !isFollowing
        ? {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('followers')
                .doc(userId)
                .set({'follow': true}).then((value) {}),
            FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('following')
                .doc(user.uid)
                .set({'follow': true}).then((value) => null)
          }
        : {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('followers')
                .doc(userId)
                .delete()
                .then((value) {}),
            FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('following')
                .doc(user.uid)
                .delete()
                .then((value) {})
          };
  }

  List followersIDs = [];
  List followers = [];

  getFollowers(UserModel user) {
    followersIDs.clear();
    followers.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('followers')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        followersIDs.add(element.id);
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          followers.add(UserModel.FromJson(value.data()));
        });
      });

    }).catchError((e) {

    });
  }

  List followingIDs = [];
  List following = [];
  Future<List?> getFollowing(UserModel user) async {
    following.clear();
    followingIDs.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        followingIDs.add(element.id);
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          following.add(UserModel.FromJson(value.data()));
        });
      });

      return following;

    }).catchError((e) {

    });
  }

  List<UserModel> users = [];
  Future getUsers() async {
    users.clear();
    emit(GetUsersLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      emit(GetUsersSuccessfulState());
      value.docs.forEach((element) {
        users.add(UserModel.FromJson(element.data()));
      });
      emit(GetUsersSuccessfulState());
    });
  }

  dynamic messageImage = File('');
  late String? messageImageUrl = '';
  Future chooseMessageImage(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      messageImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChooseImageState());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      messageImage = File(pickedImage.path);
                    } else {

                    }
                    emit(ChangeProfileState());
                    Navigator.pop(context);
                  },
                )
              ],
              title: const Text('Chose image'),
            ));
  }

  void removeMessageImage() {
    messageImage = File('');
    emit(RemoveImageState());
  }

  Future<void> uploadMessageImage() async {
    emit(UploadMessageImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(messageImage.path).pathSegments.last}')
        .putFile(messageImage)
        .then((value) async {
      //   emit(UploadCommentImageSuccessFullState());
      await value.ref.getDownloadURL().then((value) {
        messageImageUrl = value;
      }).catchError((error) {

      });
    });
  }

  sendMessage(MessageModel message) {
    emit(SendMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.receiverId)
        .collection('messages')
        .add(message.toJosn())
        .then((value) {})
        .catchError((e) {

      emit(SendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(message.receiverId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages')
        .add(message.toJosn())
        .then((value) {
      emit(SendMessageSuccessfulState());
    }).catchError((e) {

      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  Future getChat(UserModel user) async {
    // messages =[];
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(appUSer.uid)
        .collection('chats')
        .doc(user.uid)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      event.docs.forEach((element) {
        messages.add(MessageModel.FromJson(element.data()));

        //emit(SendMessageSuccessfulState());
      });
    });
    emit(GetMessageSuccessfulState());
  }
}
