import 'package:get/get.dart';

class AudioGenerateController extends GetxController {
  List<Map<String, dynamic>> audioGenerate = [
    {
      'title': 'Alice',
      'imagePath':
          'https://img.freepik.com/premium-photo/male-models-photo-album-with-full-menly-vibes-from-all-world_563241-20905.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/alice.mp3',
    },
    {
      'title': 'Aria',
      'imagePath':
          'https://img.freepik.com/premium-photo/beautiful-egirl-woman-portrait_691560-641.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Aria.mp3',
    },
    {
      'title': 'Bill',
      'imagePath':
          'https://img.freepik.com/premium-photo/cyberpunk-aesthetic-portrait-concept_659788-13875.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Bill.mp3',
    },
    {
      'title': 'Callum',
      'imagePath':
          'https://img.freepik.com/premium-photo/man-with-pair-goggles-his-face_910054-17592.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Callum.mp3',
    },
    {
      'title': 'Charlie',
      'imagePath':
          'https://img.freepik.com/premium-photo/cybersecurity-style-man_664559-162.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Charlie.mp3',
    },
    {
      'title': 'Daniel',
      'imagePath':
          'https://img.freepik.com/premium-photo/futuristic-portrait-with-neon-halo-modern_963421-1294.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Daniel.mp3',
    },
    {
      'title': 'Eric',
      'imagePath':
          'https://img.freepik.com/premium-photo/facial-identification-conceptual-illustration-stock-illustration_839035-834269.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Eric.mp3',
    }
  ];

  var isSelected = 0.obs;

  void changeSelected(int index) {
    isSelected.value = index;
  }
}
