import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ArrangeWord extends StatefulWidget {
  const ArrangeWord({super.key});

  @override
  _ArrangeWordState createState() => _ArrangeWordState();
}

class _ArrangeWordState extends State<ArrangeWord> {

  List<String> correctSentence = ['F', 'a', 't','h','e','r'];
  List<String> shuffledWords = ['a', 't', 'h','r','F','e'];
  List<String?> userAnswers = [null, null, null,null,null,null]; // Lưu câu trả lời của người dùng

  @override
  void initState() {
    shuffledWords.shuffle(); // Trộn ngẫu nhiên các từ
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
    );
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 200,
              width: 150,
              child: Center(
                child: Image.asset('assets/images/father.png'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: List.generate(correctSentence.length, (index) {
                    return InkWell( // Sử dụng InkWell cho userAnswers
                      onTap: () {
                        setState(() {
                          if (userAnswers[index] != null) {
                            shuffledWords.add(userAnswers[index]!);
                            userAnswers[index] = null;
                          }
                        });
                      },
                      child: Center(

                        /*decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),*/
                        child: Center(
                          child: Text(userAnswers[index]?.toUpperCase() ?? '', style: TextStyle(fontSize: 48),),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: shuffledWords.map((word) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      int? firstNullIndex = userAnswers.indexOf(null);
                      if (firstNullIndex != -1) {
                        userAnswers[firstNullIndex] = word;
                        shuffledWords.remove(word);
                      }
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,

                    child: Text(word),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bool isCorrect = listEquals(userAnswers, correctSentence);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isCorrect ? 'Chúc mừng!' : 'Thử lại!'),
                    content: Text(isCorrect ? 'Bạn đã ghép đúng câu.' : 'Câu trả lời chưa đúng.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Kiểm tra'),
            ),
          ],
        ),
      ),
    );
  }
}