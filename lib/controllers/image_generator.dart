import 'package:get/state_manager.dart';

import '../constants/constants.dart';

class ImageGeneratorController extends GetxController {
  List<Map<String, dynamic>> imageGenerate = [
    {
      'title': 'Anime',
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/free-photo/woman-with-bird-her-back-forest_23-2151835204.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/anime.mp3',
    },
    {
      'title': 'Low-poly',
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/free-photo/3d-portrait-people_23-2150793921.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/loy-poly.mp3',
    },
    {
      'title': 'Fantastic',
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/premium-photo/astral-ambassador-superhuman-diplomat-other-realms_839035-556669.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Fantastic.mp3',
    }
  ];

  var isSelected = 0.obs;

  void changeSelected(int index) {
    isSelected.value = index;
  }
}
