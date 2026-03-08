import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Views/home/ChatPage/Model/Chat_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Config/api_constants.dart';
import '../Services/storege_service.dart';
import '../Config/storage_constants.dart';

class SocketService extends GetxService with WidgetsBindingObserver {
  late IO.Socket socket;
  final isConnected = false.obs;
  String? _currentRoomId;

  // Stream for global message updates
  final Rxn<ChatMessage> lastReceivedMessage = Rxn<ChatMessage>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initSocket();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('📱 SocketService: App resumed, checking connection...');
      if (!socket.connected) {
        socket.connect();
      }
    }
  }

  Future<void> initSocket() async {
    // If socket already exists and is connected, don't re-init
    if (Get.isRegistered<IO.Socket>() && socket.connected) {
      debugPrint('ℹ️ SocketService: Socket already connected, skipping init');
      return;
    }

    // If exists but not connected, dispose and re-create
    if (Get.isRegistered<IO.Socket>()) {
      socket.dispose();
    }

    final token = await StorageService.getString(StorageConstants.bearerToken);
    if (token.isEmpty) {
      debugPrint('⚠️ SocketService: No token found, skipping connection');
      return;
    }

    // Extract socket URL from ApiConstants.baseUrl
    String baseUrl = ApiConstants.baseUrl;
    String socketUrl = baseUrl.replaceAll('/api/v1', '');

    debugPrint('🌐 SocketService: Initializing socket on: $socketUrl');

    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
      'randomizationFactor': 0.5,
      'timeout': 20000,
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'query': {
        'token': token, // Also send token in query for compatibility
      },
    });

    socket.onConnect((_) {
      isConnected.value = true;
      debugPrint('✅ SocketService: Connected to server');

      // Re-join room if we were in one before disconnection
      if (_currentRoomId != null) {
        debugPrint(
          '🔄 SocketService: Re-joining room after reconnection: $_currentRoomId',
        );
        socket.emit('join-room', _currentRoomId);
      }
    });

    socket.onDisconnect((_) {
      isConnected.value = false;
      debugPrint('❌ SocketService: Disconnected from server-------');
    });

    socket.onConnectError((err) {
      debugPrint('⚠️ SocketService: Connect Error: $err');
    });

    socket.onError((err) {
      debugPrint('🚨 SocketService: Error: $err');
    });

    // Reconnection events for debugging
    socket.onReconnect((_) => debugPrint('🔄 SocketService: Reconnected'));
    socket.onReconnectAttempt(
      (count) => debugPrint('🔄 SocketService: Reconnect attempt #$count'),
    );

    socket.connect();
  }

  void joinRoom(String roomId) {
    _currentRoomId = roomId;
    if (socket.connected) {
      socket.emit('join-room', roomId);
      debugPrint('➡️ SocketService: Emitted join-room for roomId: $roomId');
    } else {
      debugPrint(
        '⚠️ SocketService: Cannot join room, socket not connected. Reconnecting... RoomId: $roomId',
      );
      socket.connect();
      // Room will be joined in onConnect callback
    }
  }

  void leaveRoom(String roomId) {
    _currentRoomId = null;
    if (socket.connected) {
      socket.emit('leave-room', roomId);
      debugPrint('⬅️ SocketService: Emitted leave-room for roomId: $roomId');
    }
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
