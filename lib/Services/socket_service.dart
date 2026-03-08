import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Config/api_constants.dart';
import '../Services/storege_service.dart';
import '../Config/storage_constants.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  final isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    initSocket();
  }

  Future<void> initSocket() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);

    // Extract socket URL from ApiConstants.baseUrl
    // baseUrl: 'http://10.10.7.33:5002/api/v1' -> socketUrl: 'http://10.10.7.33:5002'
    String socketUrl = ApiConstants.baseUrl.replaceAll('/api/v1', '');

    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true, // অটো রিকানেকশন অন রাখা
      'reconnectionAttempts': 10, // রিকানেক্ট ট্রাই করার সংখ্যা বাড়ানো হলো
      'reconnectionDelay':
          1000, // রিকানেকশন শুরু করার সময় কমানো হলো (১ সেকেন্ড)
      'reconnectionDelayMax': 5000, // সর্বোচ্চ ৫ সেকেন্ড গ্যাপ দিবে
      'randomizationFactor':
          0.5, // কানেকশন ট্রাইয়ের সময় রেন্ডমাইজ করবে যাতে সার্ভারে চাপ না পড়ে
      'timeout':
          20000, // ২০ সেকেন্ড টাইমআউট (ডিফল্ট ২০০০ থাকে অনেক সময় যা কম হতে পারে)
      'extraHeaders': {'Authorization': 'Bearer $token'},
    });

    socket.onConnect((_) {
      isConnected.value = true;
      debugPrint('✅ Socket Connected');
    });

    socket.onDisconnect((_) {
      isConnected.value = false;
      debugPrint('❌ Socket Disconnected');
    });

    socket.onConnectError((err) {
      debugPrint('⚠️ Socket Connect Error: $err');
    });

    socket.onError((err) {
      debugPrint('🚨 Socket Error: $err');
    });

    socket.connect();
  }

  void joinRoom(String roomId) {
    socket.emit('join-room', roomId);
    debugPrint('➡️ Joined room: $roomId');
  }

  void leaveRoom(String roomId) {
    socket.emit('leave-room', roomId);
    debugPrint('⬅️ Left room: $roomId');
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }

  void off(String event) {
    socket.off(event);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
