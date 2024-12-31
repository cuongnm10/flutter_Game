import 'package:flutter/material.dart';
import "package:just_audio/just_audio.dart" ;
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:expand_widget/expand_widget.dart';

class FillInTheBlanks extends StatefulWidget {
  const FillInTheBlanks({super.key});

  @override
  State<FillInTheBlanks> createState() => _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  // Danh sách các TextEditingController để lưu trữ dữ liệu
  final Map<int, TextEditingController> _controllers = {};
  late TextEditingController _textEditingControllerThree;

  final audioPlayer = AudioPlayer();
  String formatDuration(Duration d){
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}";
  }
  void handlePlayPause(){
    if(audioPlayer.playing){
      audioPlayer.pause();
    }else{
      audioPlayer.play();
    }
  }
  void handleSeek(double value){
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  @override
  void initState(){
    super.initState();
    audioPlayer.setAsset('assets/audio/taisinh.mp3');

    // listen to position
    audioPlayer.positionStream.listen((p){
      setState(() => position = p);
    });
    // listen to duration update
    audioPlayer.durationStream.listen((d) {
      setState(() => duration = d!);
    });
    // listen to state changed
    audioPlayer.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed){
        setState(() {
          position = Duration.zero;
        });
        audioPlayer.pause();
        audioPlayer.seek(position);
      }

    });
    _textEditingControllerThree = TextEditingController();
  }
  @override
  void dispose() {
    // Hủy các controller khi widget bị hủy
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    audioPlayer.dispose();
    _textEditingControllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/img1.png',
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const ExpandText(
              'Example:\n'
                  '\n'
                  'What is the gift for ? For Lucy`s "12th" birthday.\n'
                  'What is the name of the cat? SUN\n',
              maxLines: 2,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            buildTextParagraph(
              context,
              [
                'Here is a wonderful opportunity at a ',
                buildTextField(context, '', 0),
                ' to visit the truly remarkable island of Cuba. We have ',
                buildTextField(context, '', 1),
                ' at some of the finest hotels for periods of 7 and 14 nights. You may ',
                buildTextField(context, '', 2),
                ' your time between relaxing and exploring this beautiful country by taking advantage of our extensive excursion programme.',
              ],
            ),
            const SizedBox(height: 24),
            buildTextParagraph(
              context,
              [
                'The ',
                buildTextField(context, '', 3),
                ' of such a small country is amazing, and, as it is set in the warm waters of the Caribbean, it is ',
                buildTextField(context, '', 4),
                ' to have one of the most pleasant climates in the world.',
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Xử lý logic khi nhấn nút Submit
                for (var entry in _controllers.entries) {
                  print('Field ${entry.key}: ${entry.value.text}');
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 10),
            Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: handleSeek,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(position)),
                  Text(formatDuration(duration - position)),
                ],

              ),
            ),
            IconButton(
                onPressed: handlePlayPause,
                icon: Icon(audioPlayer.playing? Icons.pause : Icons.play_arrow)
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm tạo từng đoạn văn
  Widget buildTextParagraph(BuildContext context, List<dynamic> parts) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.8),
        children: parts.map((part) {
          if (part is String) {
            return TextSpan(text: part);
          } else if (part is Widget) {
            return WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: part,
            );
          }
          return const TextSpan();
        }).toList(),
      ),
    );
  }

  /// Hàm tạo TextField
  Widget buildTextField(BuildContext context, String hint, int index) {
    // Tạo controller nếu chưa có
    _controllers[index] ??= TextEditingController();

    _controllers[index]?.addListener(() {
      setState(() {

      });
    });
    return AutoSizeTextField(
      controller: _controllers[index],
      decoration: InputDecoration(hintText: ''),
      fullwidth: false,
      minFontSize: 14,
      minWidth: 80,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

}