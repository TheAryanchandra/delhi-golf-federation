// import 'dart:async';


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final SplashServicesClass _splashServicesClass = SplashServicesClass();

//   @override
//   void initState() {
//     super.initState();
//     checkLoginMethod();
//   }

//   checkLoginMethod() async {
//     _splashServicesClass.isUserLoggedIn(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return Container(
//       color: ColorConstants.whiteColor,
//       width: width,
//       height: height,
//       child: Image.asset(logo), // your splash image
//     );
//   }
// }
