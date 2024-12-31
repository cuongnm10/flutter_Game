import 'package:drag_drop_item/game/fill_in_blank.dart';
import 'package:drag_drop_item/game/matching_game.dart';
import 'package:drag_drop_item/game/multiple_choice.dart';
import 'package:flutter/material.dart';
import 'extention/shuffer_word.dart';
import 'game/img_game_type1.dart';
import 'game/img_game_type2.dart';
import 'package:animations/animations.dart';

import 'game/img_game_type3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageGameDemo(),
      debugShowCheckedModeBanner: false, // Tắt banner debug
    );
  }
}

class ImageGameDemo extends StatefulWidget{
  const ImageGameDemo({super.key});
  @override
  State<ImageGameDemo> createState(){
    return _ImageGameDemo();
  }
}

class _ImageGameDemo extends State<ImageGameDemo>{
  final SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;
  int _currentPageIndex = 0;

  void _goToNextPage(){
    setState(() {
      _currentPageIndex++ ;
    });
  }
  void _goToPreviousPage(){
    setState(() {
      if(_currentPageIndex > 0){
        _currentPageIndex--;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MultipleChoice(),
      MatchingGame(),
      ImgGameType1(),
      ImgGameType2(),
      ImgGameType3(),
      ArrangeWord(),
      FillInTheBlanks()

    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Image Game'),),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
            child:   PageTransitionSwitcher(
                reverse: _currentPageIndex == 0,
                transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    ) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: _transitionType,
                    child: child,
                  );
                },
                child: pages[_currentPageIndex],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: _currentPageIndex > 0
                      ? _goToPreviousPage
                      : null,
                      child: const Icon(Icons.arrow_back)
                  ),
                  ElevatedButton(
                      onPressed: _currentPageIndex < pages.length - 1
                      ? _goToNextPage
                      :null,
                      child: const Icon(Icons.play_arrow)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
