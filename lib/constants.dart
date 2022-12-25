import 'dart:io';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/cubit/cubit.dart';

import 'cubit/states.dart';
import 'custom_icons.dart';
import 'models/comment_model.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';
var userId ;
UserModel appUSer = UserModel();
Widget PostBuilder(
    context, controller , PostModel post, int index, UserModel user, commentImage ) {
  TextEditingController commentController = TextEditingController();
  print (user.name);
  return Padding (
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Colors.white,
      elevation: 7,
      semanticContainer: true,
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Row(
              children: [
                post.image != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(post.image!),
                  child: InkWell(
                    onTap: () {},
                  ),
                )
                    : const CircleAvatar(),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text(
                        '${post.name} ',
                        style: (const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${post.dateTime}',
                          style: (const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 12)),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {

                  },
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField
                (
                controller: TextEditingController(text: '${post.caption}'),
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                maxLines: 30,
                minLines: 1,
                smartQuotesType: SmartQuotesType.enabled,
                enabled: true,
                enableInteractiveSelection: true,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          post.postImages!.length != 0
              ? Card(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  CarouselSlider (
                    items: post.postImages!
                        .map(
                          (e) => Image(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        image: NetworkImage(e),
                        fit: BoxFit.cover,
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
                        height: MediaQuery.of(context).size.height / 3,
                        onScrolled: (index) {
                          AppCubit.get(context)
                              .scrollCarousel(index!, post);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: CarouselIndicator(
                          animationDuration: 0,
                          activeColor: Colors.purple,
                          width: 7,
                          height: 7,
                          count: post.postImages!.length,
                          index: post.photoIndex,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
            ),
          )
              : Container(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Shares : 0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Likes : ${post.likes}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                 Text('Comments : ${post.comments}' ,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Container (
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      color: Colors.white10,
                      onPressed: () {},
                      icon: const Icon(
                        CustomIcons.share_1,
                        color: Colors.purple,
                        size: 20,
                      )),
                  IconButton(
                      onPressed: () {
                        AppCubit.get(context).add_removeLikes(
                          post,

                          AppCubit.get(context).postUids[index],
                        );
                      },
                      icon: post.isLiked!
                          ? const Icon(
                        CustomIcons.heart,
                        color: Colors.purple,
                        size: 20,
                      )
                          : const Icon(
                        CustomIcons.heart_empty,
                        color: Colors.purple,
                        size: 20,
                      )),
                  IconButton (
                      onPressed: () async {
                        AppCubit.get(context).commentImage = File('');

                        showBottomSheet (elevation: 5,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) {
                              //  commentImage =  AppCubit.get(context).commentImage ;

                              //   AppCubit.get(context).comments ;
                              return Builder(
                                  builder : (context)
                                  {
                                    List <CommentModel> comments =   AppCubit.get(context).comments ;
                                    AppCubit.get(context).getComments(post, AppCubit.get(context).postUids[index]).then((value) {
                                      comments =   AppCubit.get(context).comments ;
                                    });
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BlocConsumer <AppCubit ,AppStates > (
                                        listener: (context, state) {
                                        }, builder: (Context, state)
                                      {
                                        commentImage =  AppCubit.get(context).commentImage ;
                                        return  Padding
                                          (
                                          padding: const EdgeInsets.only
                                            (
                                              top: 8, left: 8  ,
                                              right: 8
                                          ),
                                          child: Column (
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                color: Colors.grey.shade100,
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.keyboard_arrow_down, size: 30, ),
                                                    Text('comments', style: TextStyle(fontWeight: FontWeight.bold,
                                                        fontSize: 16),)
                                                  ],
                                                ),),
                                              const SizedBox(height: 10,),
                                              Expanded
                                                (
                                                child: ListView.separated
                                                  (
                                                    shrinkWrap: true,
                                                    physics: const BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) =>
                                                        commentBuilder (comments[index]),
                                                    separatorBuilder: (context, index)=> const SizedBox(height: 10,),
                                                    itemCount: comments.length),
                                              ),
                                              Container(
                                                decoration :
                                                BoxDecoration
                                                  (
                                                  border: Border.all(color: Colors.grey.shade200),
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.grey[100],
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: Row (mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:
                                                  [
                                                    IconButton (icon : const Icon(Icons.image , color: Colors.purple,),
                                                        onPressed: () async {
                                                          await AppCubit.get(context).chooseCommentImage(context).
                                                          then((value) async {
                                                            commentImage =  AppCubit.get(context).commentImage ;
                                                          });

                                                          print(commentImage!.path);
                                                        },color :Colors.white10),
                                                    Container(width: 1,color: Colors.grey[400],),
                                                    Expanded
                                                      (
                                                        child:
                                                        TextField (
                                                          controller: commentController,decoration: InputDecoration(border: InputBorder.none ,
                                                          suffix: IconButton(onPressed: ()
                                                          async {
                                                            CommentModel comment = CommentModel();
                                                            comment.text = commentController.text;
                                                            comment.userImage = appUSer.image;
                                                            comment.name = appUSer.name;
                                                            comment.replies =[];
                                                            print(index);
                                                           await AppCubit.get(context).addComment
                                                              (post, AppCubit.get(context).postUids [index],
                                                                comment);
                                                           commentController.clear();
                                                           AppCubit.get(context).removeCommentImage();
                                                          },
                                                            icon:  (state is UploadCommentImageLoadingState || state is AddCommentLoadingState)? const CircularProgressIndicator():const Icon(CustomIcons.paper_plane, color:
                                                            Colors.purple,),),
                                                          contentPadding: EdgeInsets.zero,) ,
                                                          maxLines: 30,minLines: 1, ))
                                                  ],
                                                ),
                                              ),
                                              if (commentImage.path != '') Padding
                                                (
                                                padding: const EdgeInsets.all (1.0),
                                                child: Stack (
                                                  children: [
                                                    Container (width : MediaQuery.of(context).size.width/3,
                                                      height : MediaQuery.of(context).size.width/3 ,
                                                      decoration: BoxDecoration
                                                        ( image: DecorationImage(image:
                                                      FileImage ( AppCubit.
                                                      get(context).commentImage) )),),
                                                    IconButton (onPressed: ()
                                                    {
                                                      AppCubit.get(context).removeCommentImage () ;
                                                    },icon: const Icon(Icons.highlight_remove,
                                                        color: Colors.white),color: Colors.purple,)
                                                  ],
                                                ),
                                              ) else
                                                const SizedBox (height: 0,)
                                            ],

                                          ),
                                        );
                                      },
                                      ),
                                    );
                                  }
                              );
                            }
                            , enableDrag: true ,
                            constraints: const BoxConstraints(minHeight: 1,
                                maxWidth: double.infinity, minWidth: 1
                                ,maxHeight: double.infinity));

                      } ,
                      icon: const Icon(
                        CustomIcons.comment_empty,
                        color: Colors.purple,
                        size: 20,
                      )
                  ),
                ],
              ),
            ),
          ) ,
          Container (
            height: 1,
            color: Colors.grey,
          ) ,
        ],
      ),
    ),
  );
}
Widget commentBuilder (CommentModel comment){
  return Row(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
      CircleAvatar
        (
        backgroundImage: NetworkImage('${comment.userImage}'),
        ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          children: [
            Container(

              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:
                const BorderRadiusDirectional
                    .only(
                  bottomStart:
                  Radius.circular(10),
                  topEnd: Radius.circular(10),
                  bottomEnd:
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){},
                      child:  Text('${comment.name}', style: const TextStyle
                        (fontWeight: FontWeight.bold),),
                    ),
                    Container (
                      child: TextField(
                        style: const TextStyle(height: 1, fontSize: 15),
                        controller:
                        TextEditingController(
                            text:
                            '${comment.text}'),
                        readOnly: true,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none),
                        maxLines: 30,
                        minLines: 1,
                        smartQuotesType:
                        SmartQuotesType.enabled,
                        enabled: true,
                        enableInteractiveSelection:
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            comment.image != null &&  comment.image != '' ? Container(
              clipBehavior: Clip.antiAlias,
              decoration : BoxDecoration
                (
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image(image:  NetworkImage('${comment.image}'),),
            ): const SizedBox(height : 0),
            Row (children: [
              IconButton(onPressed: (){}, icon: const Icon(CustomIcons.heart_empty)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.repeat ))
            ],)
          ],
        ),
      ),
    ],
  );
}

Widget followerBuilder (UserModel user ,context)

{
  return  Container(
    width: double.maxFinite,
    child: InkWell(
      onTap: (){},
      child: Row (children: [
         CircleAvatar(
           backgroundImage:  NetworkImage('${user.image}') ,

        ),
        const SizedBox(width: 15,),
         Expanded(child :  Text ('${user.name}')),
        MaterialButton(onPressed: (){
          AppCubit.get(context).follow_unFollowUser(user, false) ;
        }, child: const Text('follow'),color: Colors.grey,textColor: Colors.white,)
      ],),
    ),
  );
}

Widget followingBuilder (UserModel user , context)
{
  bool isfollowing = true ;
  String text = isfollowing ?  'following' : 'follow' ;
  return InkWell (
    onTap: (){},
    child: Row (children: [
       CircleAvatar(backgroundImage: NetworkImage('${user.image}'),),
      const SizedBox(width: 15,),
       Expanded(child : Text ('${user.name}')),
      MaterialButton(onPressed: (){
        isfollowing = !isfollowing ;
        AppCubit.get(context).follow_unFollowUser(user, isfollowing) ;
      }, child:  Text(text),color: Colors.grey,textColor: Colors.white,)
    ],),
  );
}