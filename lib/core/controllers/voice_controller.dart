import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_message_package/voice_message_package.dart';

class GlobalVoiceController extends GetxController {
  final RxList<CustomeVoiceController> controllers = RxList<CustomeVoiceController>();

  CustomeVoiceController getController(int id) {
    return controllers.firstWhere((c) => c.id == id,
        orElse: () => throw Exception('Controller not found'));
  }

  void addController(CustomeVoiceController controller) {
    controllers.add(controller);
  }

  void removeController(CustomeVoiceController controller) {
    controllers.remove(controller);
  }

  void stopAllControllers() {
    for (var controller in controllers) {
      controller.stop();
    }
  }

  @override
  void onClose() {
    stopAllControllers();
    super.onClose();
  }
}


class CustomeVoiceController extends VoiceController {
  final int? id;

  CustomeVoiceController({
    this.id,
    required super.audioSrc,
    required super.maxDuration,
    required super.isFile,
    required VoidCallback super.onComplete,
    required VoidCallback super.onPause,
    required VoidCallback super.onPlaying,
  });

  @override
  Future<void> init() async {
    await super.init(); // Ensure parent class initialization
    // Additional initialization if needed
  }

  @override
  void stop() {
    stop(); // Ensure to call the parent class stop method
    // Additional stop logic if needed
  }

  @override
  void refresh() {
    refresh(); // Ensure to call the parent class refresh method
    // Additional refresh logic if needed
  }
}
