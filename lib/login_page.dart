import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
          ),
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Error',
              style: TextStyle(color: Colors.black),
            ),
          ),
          content:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : [
              Text(message),
            ] 
          ) ,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/Background.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  
                  // logo
                  const Text(
                    'FeelTweets',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),

                  const SizedBox(height: 50),
                  const Text(
                    'Log in',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 25),
    
                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
    
                  const SizedBox(height: 10),
                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
    
                  const SizedBox(height: 60),
    
                  
                  
    
                  const SizedBox(height: 60),
    
                  // sign in button
                  MyButton(
                    text: "Log In",
                    onTap: signUserIn,
                  ),
    
                  const SizedBox(height: 70),
    
                  // or continue with
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //         child: Text(
                  //           'Or continue with',
                  //           style: GoogleFonts.raleway(color: Colors.grey[700]),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
    
                  const SizedBox(height: 20),
    
                  // google + apple sign in buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     // google button
                  //     SquareTile(imagePath: 'lib/images/google.png'),
    
                  //     SizedBox(width: 25),
    
                  //     // apple button
                  //     SquareTile(imagePath: 'lib/images/apple.png')
                  //   ],
                  // ),
    
                  const SizedBox(height: 20),
    
                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have account?',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white54,
                          ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
