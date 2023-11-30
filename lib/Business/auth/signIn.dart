import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../Utils/widgets/background_canvas.dart';

String name = '';
String email = '';
String image = '';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  nextPage() {
    context.go('/baseRoute');
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const DetailsScreen()));
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      print("token ${googleAuth?.accessToken}");
      print("token ${googleAuth?.idToken}");
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      setState(() {
        name = user!.displayName.toString();
        email = user.email.toString();
        image = user.photoURL.toString();
      });
      nextPage();
      if (kDebugMode) {
        print("Signed in as user:  ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while signing in with Google: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomPaint(
            painter: CurvePainter(),
            child: Container(
              height: 300.0,
            ),
          ),

          const Spacer(),

          const Text("Find Your Dream Pet Here",style:TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
          const Text("join us and discover the best pet in your location!!",style:TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),
          SizedBox(height: 25,),
          InkWell(
            onTap: _signInWithGoogle,
            child: Container(
              width: 327,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(6),
                  border: Border.all(
                      color: Colors.deepOrangeAccent,
                      width: 1)),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/google_logo.png",
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Continue with Google",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "iregular"),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}