import 'package:drivers_app/Support/chat.dart';
import 'package:drivers_app/Support/support.dart';
import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/controller.dart';
import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/tabPages/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/info_design_ui.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  var controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    print(onlineDriverData.phone);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //name
              Text(
                onlineDriverData.name!,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                titleStarsRating + "driver",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  height: 2,
                  thickness: 2,
                ),
              ),

              const SizedBox(
                height: 38.0,
              ),

              //phone
              InfoDesignUIWidget(
                textInfo: onlineDriverData.phone!,
                iconData: Icons.phone_iphone,
              ),

              //email
              InfoDesignUIWidget(
                textInfo: onlineDriverData.email!,
                iconData: Icons.email,
              ),

              InfoDesignUIWidget(
                textInfo: onlineDriverData.car_color! +
                    "" +
                    onlineDriverData.car_model! +
                    "" +
                    onlineDriverData.car_number!,
                iconData: Icons.car_repair,
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                  onPressed: () {
                    fAuth.signOut();
                    Get.to(() => LoginScreen());
                    // SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: theme.primaryColor,
                    ),
                  )),

              Obx(() => IconButton(

                  // tooltip: "asd",
                  onPressed: () {
                    controller.changeTheme();
                  },
                  icon: Icon(
                    controller.isDark.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: theme.iconTheme.color,
                  ))),
              Text(
                controller.isDark.value ? " Dark mode" : "Light mode",
                style: TextStyle(color: theme.primaryColor),
              ),

              TextButton(
                  onPressed: () {
                    Get.to(() => chatpage(email:"talha@gnmail.com" ,
                        // email: onlineDriverData.email.toString(),
                        ));
                  },
                  child: Text("Contact Support team"))
            ],
          ),
        ),
      ),
    );
  }
}
