import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/models/post_model.dart';
import '../models/user_model.dart';

class NewPostScreen extends StatelessWidget {
  UserModel model;
  NewPostScreen({required this.model, Key? key}) : super(key: key);
  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New Post'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  state is CreatePostLoadingState ||
                          state is UploadImagesLoadingState
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Container(),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            model.image != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(model.image!),
                                    child: InkWell(
                                      onTap: () {},
                                    ),
                                  )
                                : CircleAvatar(),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Text(
                                    model.name ?? '',
                                    style: (TextStyle(
                                        fontWeight: FontWeight.bold)),
                                  ),
                                  onTap: () {},
                                ),
                                SizedBox(
                                  height: 3,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: captionController,
                            decoration: InputDecoration(
                                hintText: 'What on your mind...',
                                border: InputBorder.none),
                            maxLines: 30,
                            minLines: 1,
                            smartQuotesType: SmartQuotesType.enabled,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Card(
                          elevation: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.width,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.width * 1.5,
                                minHeight: 100),
                            decoration: BoxDecoration(color: Colors.white),
                            child: CarouselSlider(
                              items: AppCubit.get(context)
                                  .imagesList
                                  .map(
                                    (e) => Center(
                                      child: Stack(children: [
                                        Image(
                                          width: double.infinity,
                                          image: FileImage(e),
                                          fit: BoxFit.cover,
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            AppCubit.get(context).removeImage(
                                                AppCubit.get(context)
                                                    .imagesList,
                                                e);
                                            AppCubit.get(context).emit(state);
                                          },
                                          child: Icon(
                                            Icons.highlight_remove,
                                          ),
                                          mini: true,
                                        )
                                      ]),
                                    ),
                                  )
                                  .toList(),
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                height: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MaterialButton(
                        onPressed: () async {
                          PostModel post = PostModel(
                              caption: captionController.text,
                              uid: model.uid,
                              dateTime: DateTime.now().toString(),
                              image: model.image,
                              name: model.name);
                          await AppCubit.get(context)
                              .createPost(context: context, post: post);
                        },
                        child: Text('Post'),
                        color: Colors.purple,
                        textColor: Colors.white,
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AppCubit.get(context).addPostImages(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('AddPhotos')
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.tag, color: Colors.purple),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Tags')
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
        },
        listener: (context, state) {});
  }
}
