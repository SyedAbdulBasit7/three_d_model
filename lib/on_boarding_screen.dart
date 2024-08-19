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
  final O3DController o3dController = O3DController();
  final double initialValue = -2.0;
  final double maxValue = 12.0;
  final double resetValue = -11.0;
  final double smoothIncrement = 0.1;
  final int timerDurationMs = 50;
  final int resetDelayMs = 500;
  final int postResetDelayMs = 700;
  bool _isResetting = false;
  late double _value;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _value = initialValue;
    _startSmoothTimer();
  }

  void _startSmoothTimer() {
    _timer = Timer.periodic(Duration(milliseconds: timerDurationMs), (timer) {
      if (_isResetting) return;

      setState(() {
        _value += smoothIncrement;
        _updateCameraTarget(_value);
        if (_value > maxValue) {
          _isResetting = true;
          _smoothReset();
        }
      });
    });
  }

  void _smoothReset() async {
    await Future.delayed(Duration(milliseconds: resetDelayMs));
    _instantResetCameraPosition();
    await Future.delayed(Duration(milliseconds: postResetDelayMs));

    _value = resetValue;
    _timer = Timer.periodic(Duration(milliseconds: timerDurationMs), (timer) {
      setState(() {
        _value += smoothIncrement;
        _updateCameraTarget(_value);
        if (_value > 2) {
          timer.cancel();
          _finalizeReset();
        }
      });
    });
  }

  void _instantResetCameraPosition() {
    o3dController.cameraOrbit(0, 95, 1);
    _updateCameraTarget(resetValue);
  }

  void _finalizeReset() {
    o3dController.cameraOrbit(180, 95, 1);
    _updateCameraTarget(2);
    Future.delayed(Duration(milliseconds: postResetDelayMs), () {
      setState(() {
        _isResetting = false;
      });
    });
  }

  void _updateCameraTarget(double value) {
    o3dController.cameraTarget(0.20, 1.5, value);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE6FFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            _build3DModel(),
            _buildTextContent(),
          ],
        ),
      ),
    );
  }

  Widget _build3DModel() {
    return O3D(
      controller: o3dController,
      src: AnimatedImages.mainCat,
      alt: "A 3D model",
      autoPlay: true,
      autoRotate: false,
      cameraControls: false,
      animationName: 'WalkClean',
      cameraOrbit: CameraOrbit(180, 95, 0.5),
      cameraTarget: CameraTarget(0.20, 1.5, 2),
      interactionPrompt: InteractionPrompt.none,
      loading: Loading.eager,
    );
  }

  Widget _buildTextContent() {
    return Column(
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
    );
  }
}
