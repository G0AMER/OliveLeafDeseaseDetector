import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signup.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //controller to keep track of which page we are on
  PageController _controller = PageController();
  //keep track of if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    //_controller.jumpToPage(2);
                    press(context, SignUp());
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'titre',
                      fontSize: 24.0,
                      color: AppColors.vertfonce,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: AppColors.vertclaire,
                    activeDotColor: AppColors.vertnormal,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),

                //next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUp();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: 'titre',
                            fontSize: 24.0,
                            color: AppColors.vertfonce,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'titre',
                            fontSize: 24.0,
                            color: AppColors.vertfonce,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0), // Add left and right padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/AI1.png',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Instant olive leaf disease detection using AI model.',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: 'titre',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0), // Add left and right padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/expert.png',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ask for an expert opinion.',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: 'titre',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0), // Add left and right padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/tree1.png',
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Monitor trees' health.",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: 'titre',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
