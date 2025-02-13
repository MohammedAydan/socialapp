import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialapp/common/strings.dart';

typedef OnNotificationPermissionChangeObserver = void Function(bool permission);

typedef OnNotificationWillDisplayListener = void Function(
    OSNotificationWillDisplayEvent event);

typedef OnNotificationClickListener = void Function(
    OSNotificationClickEvent event);

class OneSignalNotificationsP {
  // ... other methods and properties ...
  Future<void> postNotification(OSCreateNotification notification) async {
    const String url = 'https://onesignal.com/api/v1/notifications';
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.authorizationHeader: 'Basic ${dotenv.env['ONESIGNAL_AUTH']}',
    };
    final String payload = json.encode(notification.toJson());

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: payload,
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}

class OSCreateNotification {
  final List<String> playerIds;
  final String contentEn;
  final String headingEn;
  final String contentAr;
  final String headingAr;
  final String? subtitle;
  final String? url;
  final Map<String, dynamic>? data;
  final List<OSActionButton>? buttons;
  final String? androidAccentColor;
  final String? smallIcon;
  final String? largeIcon;
  final String? iosSound;
  final String? androidSound;
  final String? androidChannelId;
  final bool? contentAvailable;
  final bool? mutableContent;
  final int? ttl;
  final bool? priority;

  OSCreateNotification({
    required this.playerIds,
    required this.contentEn,
    required this.headingEn,
    required this.contentAr,
    required this.headingAr,
    this.subtitle,
    this.url,
    this.data,
    this.buttons,
    this.androidAccentColor,
    this.smallIcon,
    this.largeIcon,
    this.iosSound,
    this.androidSound,
    this.androidChannelId,
    this.contentAvailable,
    this.mutableContent,
    this.ttl,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'app_id':
          ONESIGNAL_KEY, // Make sure to replace ONESIGNAL_KEY with your actual OneSignal app ID
      'include_player_ids': playerIds,
      'contents': {
        'en': contentEn,
        'ar': contentAr,
      },
      'headings': {
        'en': headingEn,
        'ar': headingAr,
      },
    };

    if (subtitle != null) json['subtitle'] = {'en': subtitle};
    if (url != null) json['url'] = url;
    if (data != null) json['data'] = data;
    if (buttons != null) {
      json['buttons'] = buttons!.map((button) => button.toJson()).toList();
    }
    if (androidAccentColor != null) {
      json['android_accent_color'] = androidAccentColor;
    }
    if (smallIcon != null) json['small_icon'] = smallIcon;
    if (largeIcon != null) json['large_icon'] = largeIcon;
    if (iosSound != null) json['ios_sound'] = iosSound;
    if (androidSound != null) json['android_sound'] = androidSound;
    if (androidChannelId != null) json['android_channel_id'] = androidChannelId;
    if (contentAvailable != null) json['content_available'] = contentAvailable;
    if (mutableContent != null) json['mutable_content'] = mutableContent;
    if (ttl != null) json['ttl'] = ttl;
    if (priority != null) json['priority'] = priority;

    return json;
  }
}

class OSActionButton {
  final String id;
  final String text;
  final String? icon;

  OSActionButton({
    required this.id,
    required this.text,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'text': text,
    };

    if (icon != null) json['icon'] = icon;

    return json;
  }
}
