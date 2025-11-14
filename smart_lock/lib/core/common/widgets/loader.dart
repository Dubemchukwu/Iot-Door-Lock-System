import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.height = 20, this.width = 20});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: SColor.white,
        ),
      ),
    );
  }
}

class IosLoader extends StatelessWidget {
  const IosLoader({super.key, this.height = 20, this.width = 20});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const CupertinoActivityIndicator(color: SColor.white),
      ),
    );
  }
}
