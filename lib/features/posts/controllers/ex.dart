// import 'package:flutter/material.dart';
// import 'package:voice_message_package/voice_message_package.dart';

// class VoiceControllerManager {
//   static final List<CustomeVoiceController> _controllers = [];

//   static CustomeVoiceController getController(int id) {
//     return _controllers.firstWhere((c) => c.id == id,
//         orElse: () => throw Exception('Controller not found'));
//   }

//   static void addController(CustomeVoiceController controller) {
//     _controllers.add(controller);
//   }

//   static void removeController(CustomeVoiceController controller) {
//     _controllers.remove(controller);
//   }

//   static void stopAllControllers() {
//     for (var controller in _controllers) {
//       controller.stop();
//     }
//   }
// }

// class CustomeVoiceController extends VoiceController {
//   final int? id;

//   CustomeVoiceController({
//     this.id,
//     required super.audioSrc,
//     required super.maxDuration,
//     required super.isFile,
//     required VoidCallback super.onComplete,
//     required VoidCallback super.onPause,
//     required VoidCallback super.onPlaying,
//   });

//   @override
//   Future<void> init() async {
//     await super.init(); // Ensure parent class initialization
//     // Additional initialization if needed
//   }

//   @override
//   void stop() {
//     stop(); // Ensure to call the parent class stop method
//     // Additional stop logic if needed
//   }

//   @override
//   void refresh() {
//     refresh(); // Ensure to call the parent class refresh method
//     // Additional refresh logic if needed
//   }
// }
