import 'package:flutter/material.dart';

class AppConstant {
  static final String messagesCollection = 'messages';
  static final String usersCollection = 'users';
}

class ColorConstant {
  static final Color backgroundColor = Colors.white;
  static final Color primaryColor = Color(0xff4CAF50);
}

List<String> imageSizeOptionsDalle2 = ["256x256", "512x512", "1024x1024"];

List<String> imageSizeOptionsDalle3 = ["1024x1024", "1024x1792", "1792x1024"];

class FirebasePaths {
  static const String chatBotsName = 'chatBots';
  static const String chatRoomsName = 'chatRooms';
  static const String usersName = 'users';
  static const String generatedImageName = 'generatedImages';
  static const String messagesName = 'messages';
  static const String settingsName = 'settings';

  // For nested collections
  static String chatRooms(String chatRoomId) => 'chatRooms/$chatRoomId';
  static String chatRoomMessages(String chatRoomId) => 'chatRooms/$chatRoomId/messages';
}

final List<Map<String, dynamic>> artStyles = [
  {"id": 1, "name": "None", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302268/VertexAI/nostyles.png"},
  {"id": 2, "name": "3D render", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302261/VertexAI/3drender.jpg"},
  {"id": 3, "name": "Pixel", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302271/VertexAI/pixel.jpg"},
  {"id": 4, "name": "Sticker", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302259/VertexAI/sticker.jpg"},
  {"id": 5, "name": "Realistic", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302273/VertexAI/realistic.jpg"},
  {"id": 6, "name": "Isometric", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302264/VertexAI/isometric.jpg"},
  {"id": 7, "name": "Cyberpunk", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302264/VertexAI/cyberpunk.jpg"},
  {"id": 8, "name": "Line art", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302265/VertexAI/lineart.jpg"},
  {"id": 9, "name": "Pencil drawing", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302271/VertexAI/pencil.png"},
  {"id": 10, "name": "Ballpoint pen drawing", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/Ballpoint.jpg"},
  {"id": 11, "name": "Watercolor", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/watercolor.jpg"},
  {"id": 12, "name": "Origami", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302270/VertexAI/origami.jpg"},
  {"id": 13, "name": "Cartoon", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302261/VertexAI/cartoon.jpg"},
  {"id": 14, "name": "Retro", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302273/VertexAI/retro.jpg"},
  {"id": 15, "name": "Anime", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/anime.jpg"},
  {"id": 16, "name": "Clay", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302262/VertexAI/clay.jpg"},
  {"id": 17, "name": "Vaporwave", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/vaporwave.jpg"},
  {"id": 18, "name": "Steampunk", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302274/VertexAI/steampunk.jpg"},
  {"id": 19, "name": "Glitchcore", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302264/VertexAI/glitch.jpg"},
  {"id": 20, "name": "Bauhaus", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302261/VertexAI/bauhaus.jpg"},
  {"id": 21, "name": "Vector", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/vectors.jpg"},
  {"id": 22, "name": "Low poly", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302265/VertexAI/lowpoly.jpg"},
  {"id": 23, "name": "Ukiyo-e", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302260/VertexAI/ukiyoe.jpg"},
  {"id": 24, "name": "Cubism", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302263/VertexAI/cubism.jpg"},
  {"id": 25, "name": "Modern", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302267/VertexAI/modern.jpg"},
  {"id": 26, "name": "Pop", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302272/VertexAI/pop.jpg"},
  {"id": 27, "name": "Contemporary", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302262/VertexAI/contemporary.jpg"},
  {"id": 28, "name": "Impressionism", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302268/VertexAI/impressionism.jpg"},
  {"id": 29, "name": "Pointillism", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302271/VertexAI/pointillism.jpg"},
  {"id": 30, "name": "Minimalism", "icon": "https://res.cloudinary.com/ladla8602/image/upload/v1704302266/VertexAI/minimalism.jpg"},
];
