import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:three_d_model/animated_images.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  O3DController o3dController = O3DController();
  int page = 0;
  String animationName = 'WalkClean';
  double _value = -2; // Initial value
  late Timer _timer;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _startSmoothTimer(); // Start the timer when the widget is initialized
  }

  void _startSmoothTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isResetting) return;
      setState(() {
        _value += 0.1; // Smaller increment for smoother transition
        o3dController.cameraTarget(0.20, 1.5, _value);
        if (_value > 12) {
          _isResetting = true;
          _smoothReset(); // Start the smooth reset process
        }
      });
    });
  }

  void _smoothReset() async {
    o3dController.cameraOrbit(0, 95, 1); // Assuming radius is fixed at 1.0
    o3dController.cameraTarget(0.20, 1.5, -12);
    await Future.delayed(const Duration(milliseconds: 700));
    _value = -12;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _value += 0.1; // Smaller increment for smoother transition
        o3dController.cameraTarget(0.20, 1.5, _value);
        if (_value > 2) {
          timer.cancel(); // Stop the reset timer
          o3dController.cameraOrbit(
              180, 95, 1); // Assuming radius is fixed at 1.0
          o3dController.cameraTarget(0.20, 1.5, 2);
          Future.delayed(
              const Duration(milliseconds: 700), () => _isResetting = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE3FFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            O3D(
              controller: o3dController,
              src: AnimatedImages.mainCat,
              alt: "A 3D model",
              autoPlay: true,
              autoRotate: false,
              cameraControls: false,
              animationName: animationName,
              cameraOrbit: CameraOrbit(180, 95, 0.5),
              cameraTarget: CameraTarget(0.20, 1.5, 2),
              interactionPrompt: InteractionPrompt.none,
              loading: Loading.eager,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Best',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Companion',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEE9D2A),
                        ),
                      ),
                      Text(
                        'With CATS',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE9D2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
