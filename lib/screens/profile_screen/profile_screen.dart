// ignore_for_file: must_be_immutable

import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/constants.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final Map lol = {
    'profile_picture':
        "https://firebasestorage.googleapis.com/v0/b/sba7-ed3fd.appspot.com/o/user_profiles%2Fdefault%2Fuser.png?alt=media&token=ed7c16f0-2765-48b3-ba8b-c21938d2d156"
  };
  DateDuration duration =
      AgeCalculator.age(DateTime.parse(userData['birth_date']));
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        cubit.getprofileImage();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 38,
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(48),
                                    child: CachedNetworkImage(
                                      imageUrl: userData['profile_picture'],
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.edit,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${toBeginningOfSentenceCase(userData['full_name'])}",
                          style:const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${duration.years} Years Old",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
                        )
                      ],
                    )
                  ],
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
                        