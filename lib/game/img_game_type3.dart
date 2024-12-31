import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Game Chọn nhân vật/con vật/ đồ vật trong 1 bức tranh khác
class ImgGameType3 extends StatefulWidget {
  const ImgGameType3({super.key});

  @override
  State<ImgGameType3> createState() => _ImgGameType3State();
}

class _ImgGameType3State extends State<ImgGameType3> {
  Map<String, List<Map<String, dynamic>>> insideImgData = {
    'img1.png': [
      {
        'top': 15.0,
        'left': 120.0,
        'width': 100.0,
        'height': 100.0,
        'acceptedData': null,
        'isChosen' : false,
        'img' : 'bird.png',
        'imgStroke' : 'bird_stroke.png'
      }, // acceptedData là null ban đầu
      {
        'top': 320.0,
        'left': 680.0,
        'width': 100.0,
        'height': 100.0,
        'acceptedData': null,
        'isChosen' : false,
        'img' : 'bee.png',
        'imgStroke' : 'bee_stroke.png'
      },
    ],
  };
  String currentImage = 'img1.png';
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
                      insideImgData[currentImage]!
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
                          ...insideImgData[currentImage]!.map((targetData) {
                            int index =
                            insideImgData[currentImage]!.indexOf(targetData);
                            //String imgLink = insideImgData[currentImage]![index]['img'];
                            return Positioned(
                              top: targetData['top']* scale,
                              left: targetData['left']* scale,
                              width: targetData['width']* scale,
                              height: targetData['height']* scale,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Reset tất cả ảnh về trạng thái không hover
                                      for (var target in insideImgData[currentImage]!) {
                                        target['isChosen'] = false;
                                      }
                                      // Đặt ảnh hiện tại thành hover
                                      insideImgData[currentImage]![index]['isChosen'] = true;
                                    });
                                  },
                                  child: !insideImgData[currentImage]![index]['isChosen']
                                      ? Image.asset('assets/images/${insideImgData[currentImage]![index]['img']}')
                                      : Image.asset('assets/images/${insideImgData[currentImage]![index]['imgStroke']}')
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

              ),
            ),
          ],
        ),
      ),
    );
  }
}
