import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../utils/notification_utlity.dart';

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final payload =
  RemoteMessage.fromMap(jsonDecode(notificationResponse.payload ?? ""));
  if (notificationResponse.payload != null) {
    debugPrint("СLICKING BUTTON");
    debugPrint("${payload.data}");
    NotificationUtility.onNotificationClickedResponse(payload.data);
    // Uncomment this section if needed
    // if (Get.find<LaravelAuthorizationController>().authenticationResponseValue.value?.data != null) {
    //   Get.find<LaravelAuthorizationController>().fetchNotifications();
    // }
    // var json = jsonDecode(notificationResponse.payload.data['data']);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Add your background message handling logic here
}

class FirebaseApi extends GetxController {
  // late final LaravelAuthorizationController authController =
  // Get.find<LaravelAuthorizationController>();
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High importance notifications',
      description: 'This channel is used for ipmortant notications',
      importance: Importance.defaultImportance);

  final _localNotifications = FlutterLocalNotificationsPlugin();
  Rx<FirebaseMessaging> firebaseMessaging = FirebaseMessaging.instance.obs;

  Future<void> initNotifications() async {
    // Check if notification permission is granted
    NotificationSettings settings = await firebaseMessaging.value.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmToken = await firebaseMessaging.value.getToken();
      debugPrint('FCM token: $fcmToken');
      if (GetPlatform.isIOS) {
        String? apnsToken;
        while (apnsToken == null) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await firebaseMessaging.value.getAPNSToken();
        }
      }
      initPushNotifications();
      initLocalNotifications();
    } else {
      // Permission not granted, handle accordingly (e.g., show message to user)
      // You can show a message to the user or take other actions here
    }
  }

  // function to handle received message
  void handleMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }

    // todo fetch only the specific data based on the notification type.
    debugPrint("${message.data}");
    NotificationUtility.onNotificationClickedResponse(message.data);
    // await Get.find<UserNotificationsController>().fetchUserNotifications();
    // await Get.find<MakeReservationController>().fetchReservations();
    // Get.toNamed(Routes.notificationCenter);
  }

  Future<void> subscribeToNotificationTopics() async {
    // if (Get.find<AuthorizationController>().token != null && Get.find<AuthorizationController>().user != null) {
    //   var topics = [
    //     'oldubiil',
    //     'user_${Get.find<AuthorizationController>().user?.id}'
    //   ];
    //   topics.forEach((element) async {
    //     debugPrint("element == $element");
    //     await firebaseMessaging.value.subscribeToTopic(element);
    //   });
    // }
    // else{
    //   debugPrint("token or user is null");
    // }
    await subscribeToNotificationTopic("all");
  }

  Future<void> subscribeToNotificationTopic(String topic) async {
    try {
      debugPrint("Attempting to subscribe to topic: $topic");
      await firebaseMessaging.value.subscribeToTopic(topic);
      debugPrint("Successfully subscribed to topic: $topic");
    } catch (e) {
      debugPrint("Error subscribing to topic: $topic - $e");
    }
  }
  Future<void> unsubscribeToNotificationTopic(String topic) async {
    try {
      debugPrint("Attempting to subscribe to topic: $topic");
      await firebaseMessaging.value.unsubscribeFromTopic(topic);
      debugPrint("Successfully subscribed to topic: $topic");
    } catch (e) {
      debugPrint("Error subscribing to topic: $topic - $e");
    }
  }

  Future<void> unSubscribeFromNotificationTopics() async {
    // Check if the user is authorized before attempting to unsubscribe
    // if (Get.find<AuthorizationController>().token != null && Get.find<AuthorizationController>().user != null) {
    //   var topics = [
    //     'oldubiil',
    //     'user_${Get.find<AuthorizationController>().user?.id}'
    //   ];
    //
    //   // Loop through each topic and unsubscribe
    //   for (String topic in topics) {
    //     debugPrint("Unsubscribing from topic: $topic");
    //     try {
    //       await firebaseMessaging.value.unsubscribeFromTopic(topic);
    //       debugPrint("Successfully unsubscribed from topic: $topic");
    //     } catch (e) {
    //       debugPrint("Error unsubscribing from topic: $topic - $e");
    //     }
    //   }
    // } else {
    //   debugPrint("token or user is null");
    // }
    unsubscribeToNotificationTopic("all");
  }

  Future initLocalNotifications() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  //function to init bg settings
  Future initPushNotifications() async {
    // handle when the app was terminated and it opeened now
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach an event listener
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification == null) {
        return;
      }
      // if(Get.find<AuthorizationController>().token != null){
      //   Get.find<NotificationController>().fetchNotifications();
      // }
      // when notification comes when app opened
      final messageData = message.data;
      NotificationUtility.onNotificationReceivedResponse(messageData);
      if(!GetPlatform.isIOS){
        _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  icon: "@mipmap/ic_launcher",
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                )),
            payload: jsonEncode(message.toMap()));
      }
      // Get.find<NotificationsController>().getNotifications();
    });
  }
}
