import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authorization_controller.dart';
import '../routes/app_routes.dart';


class NotificationUtility {
  static onNotificationClickedResponse (Map<String, dynamic>? message) {
    if(message != null){
      if((message.containsKey('my_orders'))){
        String? orderId = message['my_orders'];
        int? orderIdInt = int.tryParse(orderId ?? '');
        // Perform any actions you want with this value, here we're just printing it
        debugPrint('Product contains my_orders. Order ID: $orderId');
        if(orderIdInt != null){
          // perform actions
        }
      }
    }

  }

  static onNotificationReceivedResponse (Map<String, dynamic>? message) {
    if(message != null){
      if (message.containsKey('my_orders')) {
        String? orderId = message['my_orders'];
        int? orderIdInt = int.tryParse(orderId ?? '');
        debugPrint('Product contains my_orders. Order ID: $orderId');
        // perform actions
        if (orderIdInt != null) {
          // perform actions
        }
      }
    }

  }
}
