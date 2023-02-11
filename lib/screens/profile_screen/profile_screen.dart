import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final Map lol = {
    'profile_picture':
        "https://firebasestorage.googleapis.com/v0/b/sba7-ed3fd.appspot.com/o/user_profiles%2Fdefault%2Fuser.png?alt=media&token=ed7c16f0-2765-48b3-ba8b-c21938d2d156"
  };
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    cubit.getprofileImage();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 34,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(48),
                                child: CachedNetworkImage(
                                  imageUrl: userData['profile_picture'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            size: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }
}


// Stack(
//                             alignment: AlignmentDirectional.bottomCenter,
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor:
//                                     Theme.of(context).scaffoldBackgroundColor,
//                                 radius: 65,
//                                 child: CircleAvatar(
//                                   radius: 60,
//                                   backgroundImage: (profileImage == null)
//                                       ? NetworkImage('${userModel.image}')
//                                       : FileImage(profileImage)
//                                           as ImageProvider,
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     SocialCubit.get(context).getprofileImage();
//                                   },
//                                   icon: const CircleAvatar(
//                                       radius: 20,
//                                       child: Icon(IconBroken.Camera, size: 16)))
//                             ],
//                           ),
                        