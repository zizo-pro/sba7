import 'package:flutter/material.dart';
import 'package:sba7/screens/subscription_screen/subscription_screen.dart';
import 'package:sba7/screens/swimmers_screen/swimmers_screen.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/custom_icons.dart';

class SwimmerAdminScreen extends StatelessWidget {
  const SwimmerAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                adminGridItem(
                    onTap: () {
                      navigateTo(context, const SwimmersScreen());
                    },
                    icon: CustomIcons.swimming,
                    label: "Swimmers"),
                adminGridItem(
                    onTap: () {
                      navigateTo(context,const SubscriptionScreen());
                    },
                    icon: Icons.money,
                    label: "Subscription"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
