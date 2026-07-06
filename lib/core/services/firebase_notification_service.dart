import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moeb_26/config/constants/app_constants.dart';
import 'package:moeb_26/config/constants/storage_constants.dart';
import 'package:moeb_26/core/services/storege_service.dart';
import 'package:moeb_26/firebase_options.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('📬 Background Message: ${message.messageId}');
}

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging
  static Future<void> initialize() async {
    // Request permission (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else {
      print('❌ User declined permission');
    }

    // On iOS, we need to wait for APNS token before getting FCM token
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.ios) {
      print('🍎 Waiting for APNS Token...');
      String? apnsToken;
      int retryCount = 0;
      while (apnsToken == null && retryCount < 5) {
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          retryCount++;
          print('🍎 Retrying APNS Token ($retryCount/5)...');
        }
      }
      print('🍎 APNS Token: $apnsToken');
      
      if (apnsToken == null) {
        print('⚠️ APNS Token is still null. FCM Token might fail on physical device.');
        // If we are on a simulator, getToken() will throw an exception.
        // We can skip getToken() here or let it fail gracefully in try-catch.
      }
    }

    // Get FCM token
    try {
      String? token = await _messaging.getToken();
      print('🔑 FCM Token: $token');

      if (token != null) {
        AppConstants.fcmToken = token;
        await StorageService.setString(StorageConstants.fcmToken, token);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      if (e.toString().contains('apns-token-not-set')) {
        print('💡 Hint: If you are using a simulator, FCM will not work. Please use a physical device.');
      }
    }

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      print('🔄 FCM Token Refreshed: $newToken');
      AppConstants.fcmToken = newToken;
      await StorageService.setString(StorageConstants.fcmToken, newToken);
    });

    // TODO: Send this token to your backend
    // await sendTokenToBackend(token);

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground Message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Listen to notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notification Tapped: ${message.data}');
      _handleNotificationTap(message);
    });

    // Check if app was opened from terminated state
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App opened from notification: ${initialMessage.data}');
      _handleNotificationTap(initialMessage);
    }
  }

  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Local notification tapped: ${response.payload}');
        // Handle tap
      },
    );

    // Create notification channel (Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Show local notification when app is in foreground
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_notification',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on notification data
    Map<String, dynamic> data = message.data;

    if (data['type'] == 'order_update') {
      // Navigate to order details
      // Get.to(() => OrderDetailsScreen(orderId: data['orderId']));
    } else if (data['type'] == 'promotion') {
      // Navigate to promotions
      // Get.to(() => PromotionsScreen());
    }

    print('📍 Navigating based on: $data');
  }

  // Send token to backend
  static Future<void> sendTokenToBackend(String? token) async {
    if (token == null) return;

    // TODO: Replace with your API call
    /*
    try {
      await Dio().post(
        'YOUR_BACKEND_URL/api/save-fcm-token',
        data: {
          'userId': 'USER_ID',
          'fcmToken': token,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      print('✅ Token sent to backend');
    } catch (e) {
      print('❌ Error sending token: $e');
    }
    */
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('✅ Subscribed to topic: $topic');
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('❌ Unsubscribed from topic: $topic');
  }
}
