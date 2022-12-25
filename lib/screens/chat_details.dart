import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/constants.dart';
import 'package:lol/cubit/cubit.dart';
import 'package:lol/cubit/states.dart';
import 'package:lol/custom_icons.dart';
import 'package:lol/models/message_model.dart';
import 'package:lol/models/user_model.dart';
TextEditingController messageController = TextEditingController();
class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel = UserModel();
 late var messageImage ;
  ChatDetailsScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Builder(builder: (context) {

      AppCubit.get(context).getChat(userModel).then((value) {
        print (AppCubit.get(context).messages.length);
      });
      return BlocConsumer <AppCubit ,AppStates>(builder: (context, state) {
        return Scaffold(
        appBar: AppBar (
          elevation: 3,
          title:  Row
          (mainAxisAlignment: MainAxisAlignment.start,

            children: [
          CircleAvatar(backgroundImage: NetworkImage('${userModel.image}'),),
          SizedBox(width: 10,)  ,
          Expanded(child: Text('${userModel.name}'))
        ],),)
        ,
        body:  Column(
          children: [
          Expanded(child: AppCubit.get(context).messages.isNotEmpty  ? ListView.separated(itemBuilder: (context, index) =>
              messageBuilder(AppCubit.get(context).messages[index] ,context)
              , separatorBuilder: (context, index) => SizedBox(height: 10,),
              itemCount: AppCubit.get(context).messages.length): Container()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
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
                        await AppCubit.get(context).chooseMessageImage(context).
                        then((value) async {
                          messageImage =  AppCubit.get(context).messageImage ;
                        });

                       // print(commentImage!.path);
                      },color :Colors.white10),
                  Container(width: 1,color: Colors.grey[400],),
                  Expanded
                    (
                      child:
                      TextField (
                        controller: messageController,decoration: InputDecoration(border: InputBorder.none ,
                        contentPadding: EdgeInsets.zero,) ,
                        maxLines: 30,minLines: 1, )),
                  IconButton(onPressed: ()
                  async {
                    if (AppCubit.get(context).messageImage.path != '')
                   await AppCubit.get(context).uploadMessageImage() ;
                    MessageModel message = MessageModel();
                    message.text = messageController.text;
                    message.dateTime = DateTime.now().toString() ;
                    message.senderId = userId ;
                    message.receiverId = userModel.uid;
                    message.image = AppCubit.get(context).messageImageUrl ;
                      await AppCubit.get(context).sendMessage(message);
                    // await AppCubit.get(context).addComment
                    //   (post, AppCubit.get(context).postUids [index],
                    //     comment);
                     messageController.clear();
                    AppCubit.get(context).removeMessageImage ();
                  },
                    icon:  (state is UploadMessageImageLoadingState || state is
                    SendMessageLoadingState) ? const CircularProgressIndicator ():
                    const Icon
                      (
                      CustomIcons.paper_plane, color:
                    Colors.purple,
                    ),),              ],
              ),
            ),
          ),
          if (AppCubit.get(context).messageImage.path != '') Padding
            (
            padding: const EdgeInsets.all (1.0),
            child: Stack (
              children: [
                Container (width : MediaQuery.of(context).size.width/3,
                  height : MediaQuery.of(context).size.width/3 ,
                  decoration: BoxDecoration
                    ( image: DecorationImage(image:
                  FileImage ( AppCubit.
                  get(context).messageImage) )),),
                IconButton (onPressed: ()
                {
                  AppCubit.get(context).removeCommentImage () ;
                },icon: const Icon(Icons.highlight_remove,
                    color: Colors.white),color: Colors.purple,)
               ],
            ),
          ) else
            const SizedBox (height: 0,)
        ],),
      ) ;
    }, listener: (context , state){});
    });
  }
}
Widget messageBuilder (MessageModel message , context ){
return message.senderId == appUSer.uid ?  Padding(

  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child:   Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container
            (
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/2),
            padding: EdgeInsets.all(5),
              decoration:
          BoxDecoration(
          color :
          Colors.purple,
            borderRadius:
            BorderRadiusDirectional.only(topEnd: Radius.circular(10 ),
          bottomEnd: Radius.circular(10 ), bottomStart: Radius.circular(10 )), ),
              child:
          Text('${message.text}', style:  TextStyle (color: Colors.white, fontSize: 17),)),
          message.image != null &&  message.image != '' ?
          Container(
            width: MediaQuery.of(context).size.width /2 ,
            clipBehavior: Clip.antiAlias,
            decoration : BoxDecoration
              (

              color: Colors.grey[100],
             // borderRadius: BorderRadius.circular(10),
            ),
            child: Image(image:  NetworkImage('${message.image}'),),
          ): const SizedBox(height : 0),
        ],
      ),
    ),
) :
Padding(

  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child:   Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container
          (
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/2),
            padding: EdgeInsets.all(5),
            decoration:
            BoxDecoration(
              color :
              Colors.grey,
              borderRadius:
              BorderRadiusDirectional.only(topStart: Radius.circular(10 ),
                  bottomEnd: Radius.circular(10 ), bottomStart: Radius.circular(10 )), ),
            child:
            Text('${message.text}', style:  TextStyle (color: Colors.white, fontSize: 17),)),
        message.image != null &&  message.image != '' ?
        Container(
          width: MediaQuery.of(context).size.width /2 ,
          clipBehavior: Clip.antiAlias,
          decoration : BoxDecoration
            (

            color: Colors.grey[100],
            // borderRadius: BorderRadius.circular(10),
          ),
          child: Image(image:  NetworkImage('${message.image}'),),
        ): const SizedBox(height : 0),
      ],
    ),
  ),
) ;
}
