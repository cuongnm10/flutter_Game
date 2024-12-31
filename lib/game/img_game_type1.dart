import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Game kéo thả name vào 1 búc tranh
class ImgGameType1 extends StatefulWidget {
  const ImgGameType1({super.key});

  @override
  State<ImgGameType1> createState() => _ImgGameType1State();
}

class _ImgGameType1State extends State<ImgGameType1> {
  Map<String, List<Map<String, dynamic>>> dragTargetData = {
    'img1.png': [
      {
        'top': 5.0,
        'left': 250.0,
        'width': 100.0,
        'height': 50.0,
        'acceptedData': null
      }, // acceptedData là null ban đầu
      {
        'top': 150.0,
        'left': 480.0,
        'width': 100.0,
        'height': 50.0,
        'acceptedData': null
      },
    ],
  };
  String currentImage = 'img1.png';
  List<String> draggableItems = ['Ann', 'Mark'];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]
    );
    return MaterialApp(
      home: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 20.0),
            Expanded(
              flex: 8,
              child: Center(
                child: LayoutBuilder(
                    builder: (context, constraints) {
                      double containerWidth = constraints.maxWidth;
                      double containerHeight = constraints.maxHeight;

                      double imageOriginalWidth = 1920/2; // Thay bằng kích thước thật của ảnh
                      double imageOriginalHeight = 1080/2;

                      double scaleX = containerWidth / imageOriginalWidth;
                      double scaleY = containerHeight / imageOriginalHeight;


                      double scale = scaleX < scaleY ? scaleX : scaleY; // BoxFit.contain
                      double scaledImageWidth = imageOriginalWidth * scale;
                      double scaledImageHeight = imageOriginalHeight * scale;
                      dragTargetData[currentImage]!
                          .map((target) => {
                        'top': target['top']! * scale,
                        'left': target['left']! * scale,
                        'width': target['width']! * scale,
                        'height': target['height']! * scale,
                      })
                          .toList();
                      return Stack(
                        //fit: StackFit.expand,
                        children: [
                          Image.asset('assets/images/$currentImage',
                            fit: BoxFit.fitWidth,
                            width: scaledImageWidth,
                            height: scaledImageHeight,
                          ),
                          ...dragTargetData[currentImage]!.map((targetData) {
                            int index =
                            dragTargetData[currentImage]!.indexOf(targetData);
                            return Positioned(
                              top: targetData['top']* scale,
                              left: targetData['left']* scale,
                              width: targetData['width']* scale,
                              height: targetData['height']* scale,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    dragTargetData[currentImage]![index]
                                    ['acceptedData'] =
                                    null; // Xóa dữ liệu khi click
                                  });
                                },
                                child: DragTarget<String>(
                                  builder: (context, acceptedData, rejectedData) {
                                    if (targetData['acceptedData'] != null) {
                                      return Center(
                                          child: Container(
                                            width: targetData['width']*scale,
                                            height: targetData['height']*scale,

                                            decoration: BoxDecoration(
                                              color: Colors.pinkAccent.withOpacity(0.7),
                                              border: Border.all(color: Colors.indigo),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(targetData[
                                              'acceptedData']),
                                            ),
                                          )); // Hiển thị dữ liệu đã nhận
                                    }
                                    return Container(

                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    );
                                  },
                                  onAcceptWithDetails: (data) {
                                    setState(() {
                                      dragTargetData[currentImage]![index]
                                      ['acceptedData'] = data; // Lưu dữ liệu
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: draggableItems.map((itemName) {
                    if (dragTargetData[currentImage]!.any(
                            (element) => element['acceptedData'] == itemName)) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        child: Draggable<String>(
                          data: itemName,
                          feedback: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.teal),
                              color: Colors.lightGreenAccent,
                            ),
                        
                            width: 80,
                            height: 30,
                            child: Center(
                              child: Text(itemName,
                                  style: TextStyle(color: Colors.blue, fontSize: 20)),
                            ),
                          ),
                          childWhenDragging: Text(itemName,
                              style: TextStyle(color: Colors.transparent)),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.teal),
                                color: Colors.lightGreenAccent,
                              ),
                              width: 80,
                              height: 30,
                              child: Center(child: Text(itemName))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}