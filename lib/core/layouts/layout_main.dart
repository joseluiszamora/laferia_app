import 'package:flutter/material.dart';

class LayoutMain extends StatelessWidget {
  const LayoutMain({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // const Center(
            //   child: Image(
            //     image: AssetImage(AppImages.logo),
            //     fit: BoxFit.fill,
            //     width: 80,
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
